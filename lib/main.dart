import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_sport_super_admin/utils/permission/notification_permission.dart';
import 'package:uni_sport_super_admin/utils/theme/theme.dart';
import 'package:uni_sport_super_admin/view/auth/splash_view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationPermision().requestPermission();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('1108f2cd-f8b5-4d2f-9fcf-e42b4b9c8dd0');
  OneSignal.Notifications.addClickListener((OSNotificationClickEvent event) {
    if (event.notification.additionalData!["custom_data"]["NOTIFICATION_TYPE"] == "MESSAGE_NOTIFICATION") {
    } else {}
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Uni Sport Super Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      home: SplashView(),
    );
  }
}
