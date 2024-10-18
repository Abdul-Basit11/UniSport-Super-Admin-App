import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_sport_super_admin/utils/const/sizes.dart';
import 'package:uni_sport_super_admin/utils/widgets/image_picker_widget.dart';
import 'package:uni_sport_super_admin/view/auth/login_view/login_view.dart';

import '../../../../services/image_upload.dart';
import '../../../utils/const/colors.dart';
import '../../../utils/const/image_string.dart';
import '../../../utils/loaders/loaders.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_loaders.dart';
import '../../../utils/widgets/custom_textfield.dart';
import '../../../utils/widgets/image_builder_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? adminImage;
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    return Get.offAll(() => Loginview());
                  });
                },
                icon: const Icon(Iconsax.logout)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.sH,
                // if (file == null)
                //   Center(
                //       child: Container(
                //     height: 90,
                //     width: 90,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: AppColors.textFieldGreyColor,
                //       image: DecorationImage(
                //         fit: BoxFit.cover,
                //         image: NetworkImage(userProfileImage ??
                //             'https://surgassociates.com/wp-content/uploads/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.jpg'),
                //       ),
                //     ),
                //     child: Align(
                //       alignment: Alignment.bottomRight,
                //       child: InkWell(
                //           onTap: () {
                //             showModalBottomSheet(
                //               context: context,
                //               builder: (context) {
                //                 return ImagePickerDialog(
                //                   cameraOnTapped: () {
                //                     _getImage(ImageSource.camera);
                //                   },
                //                   galleryOntapped: () {
                //                     _getImage(ImageSource.gallery);
                //                   },
                //                 );
                //               },
                //             );
                //           },
                //           child: const Icon(
                //             Iconsax.edit,
                //             color: AppColors.kPrimaryColor,
                //           )),
                //     ),
                //   ))
                // else
                //   Center(
                //     child: InkWell(
                //       onTap: () {
                //         showModalBottomSheet(
                //             backgroundColor: Colors.transparent,
                //             enableDrag: true,
                //             context: context,
                //             builder: (context) {
                //               return ImagePickerDialog(
                //                 cameraOnTapped: () {
                //                   _getImage(ImageSource.camera);
                //                 },
                //                 galleryOntapped: () {
                //                   _getImage(ImageSource.gallery);
                //                 },
                //               );
                //             });
                //       },
                //       child: Container(
                //         clipBehavior: Clip.antiAlias,
                //         height: 90,
                //         width: 90,
                //         decoration: const BoxDecoration(
                //           shape: BoxShape.circle,
                //         ),
                //         child: Image.file(
                //           File(file!.path),
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //   ),
                20.sH,
                if (file == null)
                  Center(
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: 115,
                      width: 115,
                      child: Stack(
                        children: [
                          Container(
                              height: 90,
                              width: 90,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: userProfileImage != ""
                                  ? ImageBuilderWidget(
                                      image: userProfileImage.toString(),
                                      progressIndicatorColor: AppColors.kPrimary,
                                      imageRadius: 100,
                                      height: 90,
                                      width: 90,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        ImageString.placeholder,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.kPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return ImagePickerWidget(
                                        camera: () {
                                          _getImage(ImageSource.camera);
                                          Get.back();
                                        },
                                        gallery: () {
                                          _getImage(ImageSource.gallery);
                                          Get.back();
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: AppSizes.md,
                                  color: AppColors.kwhite,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Center(
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: 115,
                      width: 115,
                      child: Stack(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.file(
                              File(
                                file!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.kPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return ImagePickerWidget(
                                        camera: () {
                                          _getImage(ImageSource.camera);
                                          Get.back();
                                        },
                                        gallery: () {
                                          _getImage(ImageSource.gallery);
                                          Get.back();
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: AppSizes.md,
                                  color: AppColors.kwhite,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                30.sH,
                CustomTextField(controller: name, hintText: 'Name'),
                10.sH,
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.kPrimary,
                        side: const BorderSide(color: AppColors.kPrimary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      // Get.to(() => ChangePasswordScreen());
                    },
                    child: Text('Change Password'.tr),
                  ),
                ),
                30.sH,
                CustomButton(
                  title: 'Update',
                  onPressed: () {
                    updateUser();
                  },
                ),
                20.sH,
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;
  String? userProfileImage;

  void makeLoadingTrue() {
    setState(() {
      loading = true;
    });
  }

  void makeLoadingFalse() {
    setState(() {
      loading = false;
    });
  }

  ImagePicker _picker = ImagePicker();
  File? file;

  getCurrentUser() {
    FirebaseFirestore.instance
        .collection('superAdmin')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      name.text = snapshot.get('name');
      userProfileImage = snapshot.get('image');
      setState(() {});
    });
    setState(() {});
  }

  _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile!.path != "") {
      file = File(pickedFile.path);
      // print(file);
      setState(() {});

      ///upload
    } else {
      ///error
    }
  }

  updateUser() async {
    makeLoadingTrue();
    String imageURL = '';
    if (file != null) {
      imageURL = await ImageUpload().uploadImage(context, file: file!, folderName: 'super Admin');
    }
    FirebaseFirestore.instance.collection('superAdmin').doc(FirebaseAuth.instance.currentUser!.uid).set({
      "name": name.text,
      "image": imageURL != "" ? imageURL : userProfileImage,
    }, SetOptions(merge: true)).then((value) {
      makeLoadingFalse();

      Loaders.successSnackBar(title: "Success", messagse: 'Super Admin Profile Updated');
    }).onError((error, stackTrace) {
      makeLoadingFalse();
    });
  }
}
