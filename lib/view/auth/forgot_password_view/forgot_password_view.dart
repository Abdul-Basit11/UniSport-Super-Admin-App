import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_sport_super_admin/utils/const/sizes.dart';
import 'package:uni_sport_super_admin/view/auth/login_view/login_view.dart';

import '../../../utils/const/image_string.dart';
import '../../../utils/const/text_string.dart';
import '../../../utils/loaders/loaders.dart';
import '../../../utils/validators/validators.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_screen_title.dart';
import '../../../utils/widgets/custom_textfield.dart';

class ForgotPasswordView extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  final forgotKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            key: forgotKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.spaceBtwSection),
              const SizedBox(
                height: AppSizes.spaceBtwSection,
              ),
              Image.asset(
                ImageString.appLogo,
                width: 100,
              ),
              CustomScreenTitle(
                title: TextString.forgotPassword,
              ),
              15.sH,
              Text('Input your email address to fix the issue'),
              SizedBox(height: AppSizes.spaceBtwItem * 2),
              CustomTextField(
                validator: (v) => Validators.validateEmail(v),
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Iconsax.direct_right,
                isPrefixIcon: true,
              ),
              SizedBox(height: AppSizes.spaceBtwItem),
              CustomButton(
                title: 'Send Email',
                onPressed: () {
                  if (forgotKey.currentState != null && forgotKey.currentState!.validate()) {
                    sendEmailResetPassword(emailController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendEmailResetPassword(String email) {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.back();
    } on FirebaseAuthException catch (e) {
      Loaders.errorSnackBar(title: e.message.toString());
    } on FirebaseException catch (e) {
      Loaders.errorSnackBar(title: e.message.toString());
    } catch (e) {
      Loaders.errorSnackBar(title: e.toString());
    }
  }
}
