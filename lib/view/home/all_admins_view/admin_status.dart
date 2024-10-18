import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:uni_sport_super_admin/utils/const/back_end_config.dart';
import 'package:uni_sport_super_admin/utils/const/sizes.dart';
import 'package:http/http.dart' as http;
import '../../../utils/const/colors.dart';
import '../../../utils/const/image_string.dart';

class AdminStatus extends StatefulWidget {
  final bool isApproved;

  const AdminStatus({super.key, required this.isApproved});

  @override
  State<AdminStatus> createState() => _AdminStatusState();
}

class _AdminStatusState extends State<AdminStatus> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BackEndConfig.adminsCollection.where('isApproved', isEqualTo: widget.isApproved).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.kPrimary,
            ),
          ); // Or any other loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text("error:" + "${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: widget.isApproved
                ? Text(
                    'No User Available',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                  )
                : Text(
                    'No Admin have created account !',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                  ),
          ); // Or any other appropriate message
        }
        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
              child: Banner(
                color: data['isBlocked'] == true
                    ? AppColors.kPrimary
                    : data['isApproved'] == true
                        ? AppColors.kGreenColor
                        : AppColors.kErrorColor,
                location: BannerLocation.topStart,
                message: data['isBlocked'] == true
                    ? 'Blocked'
                    : data['isApproved'] == true
                        ? 'Approved'
                        : 'Pending',
                child: Card(
                  elevation: 7,
                  color: AppColors.kGrey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    child: Row(
                      children: [
                        data['image'] == ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  ImageString.placeholder,
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Card(
                                clipBehavior: Clip.antiAlias,
                                shape: const CircleBorder(side: BorderSide(color: AppColors.kPrimary)),
                                child: CachedNetworkImage(
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                  imageUrl: data['image'].toString(),
                                  placeholder: (context, url) => Container(
                                    width: 20,
                                    height: 20,
                                    color: AppColors.kLightGrey, // Placeholder background color
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                          // Loader color
                                          ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                        10.sW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(data['departmentName']),
                            ],
                          ),
                        ),
                        Spacer(),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: data['isApproved'] == false
                                    ? () {
                                        BackEndConfig.adminsCollection.doc(data.id).set(
                                          {
                                            'isApproved': true,
                                          },
                                          SetOptions(merge: true),
                                        ).then((v) async {
                                          String playerId = await getAdminId(data['uid'].toString());
                                          print('this is the approved admin id $playerId');
                                          sendNotification(
                                              'Congratulations 🎉\nSuper Admin Approved your Account', playerId);
                                        });
                                      }
                                    : data['isBlocked'] == true
                                        ? () {
                                            BackEndConfig.adminsCollection.doc(data.id).set(
                                              {
                                                'isBlocked': false,
                                              },
                                              SetOptions(merge: true),
                                            ).then((v) async {
                                              String playerId = await getAdminId(data['uid'].toString());
                                              sendNotification('Your Account is Unblock now ', playerId);
                                            });
                                          }
                                        : () {
                                            BackEndConfig.adminsCollection.doc(data.id).set(
                                              {
                                                'isBlocked': true,
                                              },
                                              SetOptions(merge: true),
                                            ).then((v) async {
                                              String playerId = await getAdminId(data['uid'].toString());
                                              print("this is the admin id of O $playerId");
                                              await sendNotification(
                                                  'Super Admin Blocked your Account due to some reason', playerId);
                                            });
                                          },
                                height: 30,
                                child: Text(data['isApproved'] == false
                                    ? 'Approved'
                                    : data['isBlocked'] == true
                                        ? 'UnBlock'
                                        : 'Blocked'),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String> getAdminId(String usersId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('tokens').doc(usersId).get();
    // setState(() {});
    return documentSnapshot.get('id');
  }

  sendNotification(String content, String playerID) async {
    var headers = {
      'Authorization': 'Bearer MzFmZTM5NWEtM2NjYS00NzA3LTg0OTctOGJmZjg2YjdiYzRl',
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('https://onesignal.com/api/v1/notifications'));
    request.body = json.encode({
      "app_id": "1108f2cd-f8b5-4d2f-9fcf-e42b4b9c8dd0",
      "include_player_ids": [playerID],
      // "include_player_ids": ["ade0858e-5c24-4115-950c-464526346bc4"],
      "contents": {"en": content}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
