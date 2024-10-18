import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:http/http.dart' as http;
import 'package:uni_sport_super_admin/utils/const/back_end_config.dart';
import 'package:uni_sport_super_admin/utils/const/sizes.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/const/image_string.dart';

class EventsStatus extends StatefulWidget {
  final bool isApproved;

  const EventsStatus({super.key, required this.isApproved});

  @override
  State<EventsStatus> createState() => _EventsStatusState();
}

class _EventsStatusState extends State<EventsStatus> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BackEndConfig.eventsCollection.where('isApproved', isEqualTo: widget.isApproved).snapshots(),
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
                    'No Events are Approved yet !',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                  )
                : Text(
                    'No Events are created yet !',
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
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Banner(
                message: data['isApproved'] == true ? 'Approved' : 'Pending',
                color: data['isApproved'] == true ? Colors.green : AppColors.kErrorColor,
                location: BannerLocation.topStart,
                child: CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: Card(
                    color: AppColors.kGrey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: 100,
                              height: 90,
                              imageUrl: data['event_image'].toString(),
                              placeholder: (context, url) => Container(
                                width: 60,
                                height: 60,
                                color: AppColors.kGreenColor, // Placeholder background color
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.kPrimary, // Loader color
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
                                  data['event_name'],
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Created By:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppColors.kSecondary, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data['event_organizer_name'],
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // email
                                Text(
                                  'Event Game Name:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppColors.kSecondary, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data['event_game_name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // show only in pending
                          data['isApproved'] == true
                              ? SizedBox()
                              : PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        onTap: () {
                                          BackEndConfig.eventsCollection.doc(data.id).set(
                                            {
                                              'isApproved': true,
                                            },
                                            SetOptions(merge: true),
                                          ).then((v) async {
                                            String playerId = await getAdminId(data['admin_uid'].toString());
                                            sendNotification(
                                                'Congratulations 🎉\nSuper Admin Approved your event\n${data['event_name']}',
                                                playerId);
                                          });
                                        },
                                        height: 30,
                                        child: Text('Approved'),
                                      ),
                                    ];
                                  },
                                ),
                        ],
                      ),
                    ), // child: ExpansionTile(
                    //
                    //   initiallyExpanded: true,
                    //   maintainState: false,
                    //   tilePadding: const EdgeInsets.all(8),
                    //   //expandedAlignment: Alignment.centerLeft,
                    //   title: Text(
                    //     'Event Name',
                    //     style: Theme.of(context).textTheme.bodyLarge,
                    //   ),
                    //   shape: RoundedRectangleBorder(
                    //       side: const BorderSide(color: AppColors.kPrimary), borderRadius: BorderRadius.circular(12)),
                    //   subtitle: const Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Created By: Sir Adnan',
                    //         style: TextStyle(
                    //           fontSize: 11,
                    //           fontWeight: FontWeight.w300,
                    //         ),
                    //         maxLines: 2,
                    //       ),
                    //       Text(
                    //         'Email: adnan@gmail.com',
                    //         style: TextStyle(
                    //           fontSize: 11,
                    //           fontWeight: FontWeight.w300,
                    //         ),
                    //         maxLines: 2,
                    //       ),
                    //     ],
                    //   ),
                    //   leading: ClipRRect(
                    //     borderRadius: BorderRadius.circular(10),
                    //     child: Image.asset(
                    //       ImageString.eventImage,
                    //       width: 90,
                    //       fit: BoxFit.cover,
                    //       height: 100,
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String> getAdminId(String adminId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('tokens').doc(adminId).get();
    setState(() {});
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
