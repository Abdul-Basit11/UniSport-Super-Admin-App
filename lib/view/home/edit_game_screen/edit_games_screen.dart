// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:uni_sport_super_admin/utils/loaders/loaders.dart';
// import 'package:uni_sport_super_admin/utils/widgets/custom_textfield.dart';
//
// class EditGamesScreen extends StatefulWidget {
//   const EditGamesScreen({super.key});
//
//   @override
//   State<EditGamesScreen> createState() => _EditGamesScreenState();
// }
//
// class _EditGamesScreenState extends State<EditGamesScreen> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Games'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: kToolbarHeight),
//           CustomTextField(
//             hintText: '',
//           ),
//         ],
//       ),
//     );
//   }
//
//   getGames(){
//     FirebaseFirestore.instance.collection('games').doc().set({
//
//     }).then((v){
//       Loaders.successSnackBar(title: 'Success',messagse: 'Game Upadted' );
//     });
//   }
// }
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/image_upload.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/loaders/loaders.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_loaders.dart';
import '../../../utils/widgets/custom_textfield.dart';
import '../../../utils/widgets/image_builder_widget.dart';
import '../../../utils/widgets/image_picker_widget.dart';

class EditGameScreen extends StatefulWidget {
  final dynamic data;

  const EditGameScreen({super.key, this.data});

  @override
  State<EditGameScreen> createState() => _EditGameScreenState();
}

class _EditGameScreenState extends State<EditGameScreen> {
  TextEditingController name = TextEditingController();
  String? dateImage;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.data['game_name']);
    dateImage = widget.data['game_logo'];
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Game'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                // dateImage != null && file == null
                //     ?
                //
                // ImageBuilderWidget(
                //       image: dateImage!,
                //       height: 100,
                //       width: 100,
                //       imageRadius: 100,
                //       progressIndicatorColor: AppColors.kPrimaryColor,
                //     )
                //     : Container(
                //       height: 100,
                //       width: 100,
                //       clipBehavior: Clip.antiAlias,
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: AppColors.textFieldGreyColor,
                //       ),
                //       child: Image.file(
                //         File(file!.path),
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                SizedBox(
                  height: 20,
                ),
                dateImage != null && file == null
                    ? Container(
                        alignment: Alignment.topLeft,
                        height: 115,
                        width: 115,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(
                          children: [
                            PhysicalModel(
                              shape: BoxShape.circle,
                              elevation: 10,
                              color: AppColors.kLightGrey.withOpacity(0.5),
                              child: Container(
                                height: 100,
                                width: 100,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.kGrey,
                                ),
                                child: ImageBuilderWidget(
                                  image: dateImage!,
                                  height: 100,
                                  width: 100,
                                  imageRadius: 100,
                                  progressIndicatorColor: AppColors.kPrimary,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
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
                                            _pickImage(ImageSource.camera);
                                            Get.back();
                                          },
                                          gallery: () {
                                            _pickImage(ImageSource.gallery);
                                            Get.back();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: AppColors.kwhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        alignment: Alignment.topLeft,
                        height: 115,
                        width: 115,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(
                          children: [
                            PhysicalModel(
                              shape: BoxShape.circle,
                              elevation: 10,
                              color: AppColors.kGrey.withOpacity(0.5),
                              child: Container(
                                height: 100,
                                width: 100,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.kLightGrey,
                                ),
                                child: Image.file(
                                  File(file!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
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
                                            _pickImage(ImageSource.camera);
                                            Get.back();
                                          },
                                          gallery: () {
                                            _pickImage(ImageSource.gallery);
                                            Get.back();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: AppColors.kwhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: name,
                  hintText: 'Menu Name',
                ),
                SizedBox(
                  height: 40,
                ),
                CustomButton(
                  title: 'update',
                  onPressed: () {
                    updateMenu();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;

  makeLoadingFalse() {
    setState(() {
      loading = false;
    });
  }

  makeLoadingTrue() {
    setState(() {
      loading = true;
    });
  }

  updateMenu() async {
    makeLoadingTrue();
    String? imageURL = dateImage;
    if (file != null) {
      imageURL = await ImageUpload().uploadImage(context, file: file!, folderName: 'Menu');
    }
    // if (imageURL != null && dateImage != null && dateImage!.isNotEmpty) {
    //   await ImageUpload().deleteImage(dateImage!);
    // }
    await FirebaseFirestore.instance.collection('games').doc(widget.data['game_id']).set(
      {
        'game_name': name.text,
        'game_logo': imageURL != '' ? imageURL : dateImage,
      },
      SetOptions(merge: true),
    ).then((value) {
      makeLoadingFalse();
      Get.back();
      Loaders.successSnackBar(title: 'Update Successfully');
    });
  }

  ImagePicker _picker = ImagePicker();
  File? file;

  _pickImage(ImageSource imageSource) async {
    final pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile!.path != "") {
      file = File(pickedFile.path);
      Loaders.warningSnackBar(title: 'Warning', messagse: 'wait until image load fully');
      print(file);
      setState(() {});
    } else {}
  }
}
