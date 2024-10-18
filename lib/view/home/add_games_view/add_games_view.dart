import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_sport_super_admin/utils/const/back_end_config.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_loaders.dart';

import '../../../services/image_upload.dart';
import '../../../utils/const/colors.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/loaders/loaders.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_textfield.dart';
import '../../../utils/widgets/image_picker_widget.dart';

class AddGamesView extends StatefulWidget {
  @override
  State<AddGamesView> createState() => _AddGamesViewState();
}

class _AddGamesViewState extends State<AddGamesView> {
  TextEditingController gameNameController = TextEditingController();
  final _addGameKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Games'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
            child: Column(
              key: _addGameKey,
              children: [
                20.sH,
                file == null
                    ? Center(
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          dashPattern: [8],
                          radius: const Radius.circular(12),
                          padding: const EdgeInsets.all(6),
                          color: AppColors.kPrimary,
                          child: Container(
                            height: 120,
                            width: 120,
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
                                          _pickImage(ImageSource.camera);
                                        },
                                        gallery: () {
                                          Navigator.pop(context);

                                          _pickImage(ImageSource.gallery);
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
                                    _pickImage(ImageSource.camera);
                                  },
                                  gallery: () {
                                    Navigator.pop(context);

                                    _pickImage(ImageSource.gallery);
                                  },
                                );
                              },
                            );
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            dashPattern: [8],
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.all(6),
                            color: AppColors.kPrimary,
                            child: Container(
                              height: 120,
                              width: 120,
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
                CustomTextField(
                  controller: gameNameController,
                  validator: (va) {
                    if (va.isEmpty) {
                      return 'Enter the Game Name';
                    }
                  },
                  hintText: 'Game Name',
                  prefixIcon: Icons.games_rounded,
                  isPrefixIcon: true,
                ),
                40.sH,
                CustomButton(
                    title: 'Add',
                    onPressed: () {
                      if (file == null) {
                        return Loaders.warningSnackBar(title: 'Warning', messagse: 'Please Select the image !');
                      }
                      if (gameNameController.text.isEmpty) {
                        return Loaders.warningSnackBar(title: 'Warning', messagse: 'Enter Game Name');
                      } else {
                        return addGames();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  makeLoadingTrue() {
    setState(() {
      isLoading = true;
    });
  }

  makeLoadingFalse() {
    setState(() {
      isLoading = false;
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

  addGames() async {
    makeLoadingTrue();
    String? imageURl;
    if (file != null) {
      imageURl = await ImageUpload().uploadImage(context, file: file!, folderName: 'gameLogo');
    }
    String gameId = BackEndConfig.gamesCollection.doc().id;
    await BackEndConfig.gamesCollection.doc(gameId).set({
      'game_name': gameNameController.text.toString(),
      'game_id': gameId,
      'game_logo': imageURl,
    }).then(
      (v) {
        makeLoadingFalse();
        Get.back();
        Loaders.successSnackBar(title: 'Success', messagse: 'Game added');
      },
    );
  }
}
