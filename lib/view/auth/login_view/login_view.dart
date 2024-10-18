import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_sport_super_admin/utils/const/colors.dart';
import 'package:uni_sport_super_admin/utils/helper/helper_function.dart';
import 'package:uni_sport_super_admin/utils/validators/validators.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_button.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_loaders.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_screen_title.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_textfield.dart';
import 'package:uni_sport_super_admin/view/auth/forgot_password_view/forgot_password_view.dart';
import 'package:uni_sport_super_admin/view/home/navigation_view/naviation_view.dart';

import '../../../utils/const/image_string.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/const/text_string.dart';
import '../../../utils/loaders/loaders.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final auth = FirebaseAuth.instance;
  final email = TextEditingController(text: 'superadmin@gmail.com');
  final password = TextEditingController(text: '121212');
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: AppSizes.spaceBtwSection,
                  ),
                  Image.asset(
                    ImageString.appLogo,
                    width: 100,
                  ),
                  CustomScreenTitle(
                    title: TextString.welcomeBack,
                  ),
                  15.sH,
                  Text('Sign in to Continue'),
                  SizedBox(height: AppSizes.spaceBtwItem * 2),
                  CustomTextField(
                    validator: Validators.validateEmail,
                    hintText: 'Email',
                    controller: email,
                    textInputType: TextInputType.emailAddress,
                  ),
                  CustomTextField(
                    validator: Validators.validatePassword,
                    hintText: 'Password',
                    controller: password,
                    isPasswordField: true,
                    obsecureText: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          BHelperFunction.navigate(context, ForgotPasswordView());
                        },
                        child: Text(
                          "${TextString.forgotPassword}  ?",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.kPrimary),
                        )),
                  ),
                  SizedBox(height: AppSizes.spaceBtwItem),
                  CustomButton(
                    title: 'Login',
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        login(context: context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  makeLoadingFalse() {
    setState(() {
      isLoading = false;
    });
  }

  makeLoadingTrue() {
    setState(() {
      isLoading = true;
    });
  }

  login({context}) async {
    try {
      makeLoadingTrue();
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {
        makeLoadingFalse();
        Get.to(() => NavigationView());
        // BLoaders.customToast(message: 'Logged in ${value.user!.email}');
        Loaders.successSnackBar(title: 'Login Successfully', messagse: value.user!.email.toString());

        // Get.offAll(() => DashBoardScreen());
      });
    } on FirebaseAuthException catch (e) {
      makeLoadingFalse();
      Loaders.errorSnackBar(title: 'Error', messagse: e.code.toString());
    }
  }
}
