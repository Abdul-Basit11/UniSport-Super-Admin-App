import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_sport_super_admin/controller/count_controller.dart';
import 'package:uni_sport_super_admin/services/image_upload.dart';
import 'package:uni_sport_super_admin/utils/const/back_end_config.dart';
import 'package:uni_sport_super_admin/utils/const/colors.dart';
import 'package:uni_sport_super_admin/utils/const/sizes.dart';
import 'package:uni_sport_super_admin/utils/loaders/loaders.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_button.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_textfield.dart';
import 'package:uni_sport_super_admin/view/home/add_games_view/add_games_view.dart';
import 'package:uni_sport_super_admin/view/home/edit_game_screen/edit_games_screen.dart';
import 'package:uni_sport_super_admin/view/home/home_view/widget/dashboard_cards.dart';

import '../../../utils/const/image_string.dart';
import '../../../utils/helper/helper_function.dart';
import '../../../utils/widgets/custom_divider.dart';
import '../../../utils/widgets/image_builder_widget.dart';
import '../../../utils/widgets/image_picker_widget.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final countControlle = Get.put(CountController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              height: 45,
              width: 45,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: profileimage == ''
                  ? Image.asset(
                      ImageString.placeholder,
                      fit: BoxFit.cover,
                    )
                  : ImageBuilderWidget(
                      height: 45,
                      width: 45,
                      image: profileimage.toString(),
                    ),
            ),
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Status:',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            5.sW,
            Text(
              'Super Admin',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.spaceBtwSection),
              FutureBuilder(
                future: countControlle.getCounts(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kPrimary,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  var countData = snapshot.data;
                  return Column(
                    children: [
                      Row(
                        children: [
                          DashboardCards(title: 'Approved\nAdmins', subtitle: countData[0].toString()),
                          10.sW,
                          DashboardCards(title: 'Pending\nAdmins', subtitle: countData[1].toString()),
                        ],
                      ),
                      8.sH,
                      Row(
                        children: [
                          DashboardCards(title: 'Approved\nEvents', subtitle: countData[2].toString()),
                          10.sW,
                          DashboardCards(title: 'Pending\nEvents', subtitle: countData[3].toString()),
                        ],
                      ),
                      8.sH,
                      Row(
                        children: [
                          DashboardCards(title: 'Total\nGames', subtitle: countData[4].toString()),
                          10.sW,
                          DashboardCards(title: 'Total\nDepartments', subtitle: countData[5].toString()),
                        ],
                      ),
                    ],
                  );
                },
              ),
              20.sH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Banners',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                      onPressed: () {
                        showBannerDialog(context);
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Iconsax.add_circle5,
                        color: AppColors.kPrimary,
                        size: AppSizes.iconMd,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Department',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                      onPressed: () {
                        showDepartmentDialog(context);
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Iconsax.add_circle5,
                        color: AppColors.kPrimary,
                        size: AppSizes.iconMd,
                      )),
                ],
              ),
              15.sH,
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your Games\t\t',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextSpan(
                      text: 'º 4',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.kPrimary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              15.sH,
              StreamBuilder(
                stream: BackEndConfig.gamesCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Games Added yet !',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    Text(
                      'Some Thing Went Wrong 🚫',
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kPrimary,
                        strokeWidth: 5,
                      ),
                    );
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var game = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: CupertinoButton(
                            onPressed: () {
                              Get.to(
                                () => EditGameScreen(
                                  data: game,
                                ),
                              );
                            },
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                DottedBorder(
                                  borderType: BorderType.Circle,
                                  dashPattern: [8],
                                  radius: const Radius.circular(12),
                                  padding: const EdgeInsets.all(6),
                                  strokeWidth: 0.5,
                                  color: AppColors.kPrimary,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 38,
                                      height: 38,
                                      imageUrl: game['game_logo'],
                                      placeholder: (context, url) => Container(
                                        width: 10,
                                        height: 10,
                                        color: AppColors.kGreenColor, // Placeholder background color
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.kPrimary, // Loader color
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.downloading),
                                    ),
                                  ),
                                ),
                                8.sH,
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    game['game_name'],
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              8.sH,
              CustomDivider(),
              10.sH,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          BHelperFunction.navigate(context, AddGamesView());
        },
        label: Text('Add Games'),
      ),
    );
  }

  void showDepartmentDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            TextEditingController depName = TextEditingController();
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Card(
                color: AppColors.kGrey,
                //color: BHelperFunction.isDarkMode(context) ? AppColors.kLightOrange : AppColors.kLightOrange,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      10.sH,
                      Center(
                        child: Text(
                          'Add Department',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.kSecondary),
                        ),
                      ),
                      20.sH,
                      CustomTextField(
                        controller: depName,
                        hintText: 'Department Name',
                      ),
                      CustomButton(
                        title: 'Add',
                        onPressed: () {
                          addDepartment(context, depName.text.toString());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showBannerDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Card(
                color: AppColors.kGrey,
                //color: BHelperFunction.isDarkMode(context) ? AppColors.kLightOrange : AppColors.kLightOrange,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      10.sH,
                      Center(
                        child: Text(
                          'Upload Banner',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.kSecondary),
                        ),
                      ),
                      15.sH,
                      // banner image section
                      file == null
                          ? Center(
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                dashPattern: const [8],
                                radius: const Radius.circular(12),
                                padding: const EdgeInsets.all(6),
                                color: AppColors.kPrimary,
                                child: Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration:
                                      BoxDecoration(color: AppColors.kPrimary, borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          isDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return ImagePickerWidget(
                                              camera: () {
                                                Navigator.pop(context);
                                                _pickImage(ImageSource.camera).then((v) {
                                                  setState(() {});
                                                });
                                              },
                                              gallery: () {
                                                Navigator.pop(context);

                                                _pickImage(ImageSource.gallery).then((v) {
                                                  setState(() {});
                                                });
                                                ;
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Iconsax.camera),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ImagePickerWidget(
                                        camera: () {
                                          Navigator.pop(context);
                                          _pickImage(ImageSource.camera).then((v) {
                                            setState(() {});
                                          });
                                        },
                                        gallery: () {
                                          Navigator.pop(context);

                                          _pickImage(ImageSource.gallery).then((v) {
                                            setState(() {});
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  dashPattern: [8],
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  color: AppColors.kPrimary,
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        file!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                      20.sH,
                      CustomButton(
                        title: 'Upload',
                        onPressed: () {
                          addBanner(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String? profileimage;

  getCurrentUser() {
    BackEndConfig.superAdminCollection.doc(FirebaseAuth.instance.currentUser!.uid).snapshots().listen(
      (DocumentSnapshot snapShot) {
        profileimage = snapShot.get('image');
        setState(() {});
      },
    );
  }

  addBanner(BuildContext context) async {
    String? imageURl;
    if (file != null) {
      imageURl = await ImageUpload().uploadImage(context, file: file!, folderName: 'banners');
    }
    BackEndConfig.bannerCollection.doc().set({
      'banner': imageURl,
    }).then((v) {
      Navigator.pop(context);
      Loaders.successSnackBar(title: 'Success', messagse: 'Banner Added');
    });
  }

  addDepartment(BuildContext context, depName) async {
    String depId = BackEndConfig.departmentCollection.doc().id;
    BackEndConfig.departmentCollection.doc(depId).set({
      'department_name': depName,
      'department_id': depId,
      'is_selected': false,
    }).then((v) {
      Navigator.pop(context);
      Loaders.successSnackBar(title: 'Success', messagse: 'Department Added');
    });
  }

  File? file;

  ImagePicker imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    setState(() {
      file = File(pickedFile!.path);
    });
  }

  final storage = const FlutterSecureStorage();

  _regPlayerID() async {
    final tokenID = OneSignal.User.pushSubscription.id;
    if (tokenID != null) {
      String palyeriD = await storage.read(key: "playerID") ?? "";
      if (palyeriD != tokenID) {
        ///update token in firebase
        FirebaseFirestore.instance.collection('tokens').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'id': tokenID,
        }, SetOptions(merge: true)).then((value) {
          storage.write(key: "playerID", value: tokenID);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _regPlayerID();
  }
}
