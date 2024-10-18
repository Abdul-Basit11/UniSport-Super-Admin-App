import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/helper/helper_function.dart';
import '../all_admins_view/all_admin_view.dart';
import '../all_events_view/all_events_view.dart';
import '../home_view/home_view.dart';
import '../setting_view/setting_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final List _screenList = [
    HomeView(),
    AllAdminView(),
    AllEventsView(),
    ProfileScreen(),
  ];
  int currentIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunction.isDarkMode(context);
    return Scaffold(
      body: _screenList[currentIndex],
      bottomNavigationBar: NavigationBar(
        // height: 70,
        backgroundColor: dark ? AppColors.kSecondary : AppColors.kGrey,
        indicatorShape: BeveledRectangleBorder(side: BorderSide(color: AppColors.kwhite, width: 0.5)),
        elevation: 5,
        labelBehavior: labelBehavior,
        animationDuration: Duration(milliseconds: 700),
        selectedIndex: currentIndex,
        indicatorColor: dark ? AppColors.kPrimary : AppColors.kSecondary,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'Dashboard',
            selectedIcon: Icon(
              Iconsax.home,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.people),
            label: 'Admins',
            selectedIcon: Icon(
              Iconsax.people,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.menu),
            label: 'Events',
            selectedIcon: Icon(
              Iconsax.menu5,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.settings),
            label: 'Setting',
            selectedIcon: Icon(
              CupertinoIcons.settings_solid,
              color: dark ? AppColors.kwhite : AppColors.kwhite,
            ),
          ),
        ],
      ),
    );
  }
}
