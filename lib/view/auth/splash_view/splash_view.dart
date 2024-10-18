import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_sport_super_admin/view/auth/login_view/login_view.dart';

import '../../../utils/const/image_string.dart';
import '../../../utils/helper/helper_function.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  User? user;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      BHelperFunction.navigate(context, Loginview());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              ImageString.appLogo,
              width: 200,
            ),
            Text(
              'Efficiency at its Finest',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
