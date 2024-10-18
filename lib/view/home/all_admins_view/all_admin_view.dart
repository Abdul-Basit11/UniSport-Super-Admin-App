import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_sport_super_admin/utils/const/colors.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_divider.dart';

import '../../../utils/const/sizes.dart';
import 'admin_status.dart';

class AllAdminView extends StatefulWidget {
  @override
  State<AllAdminView> createState() => _AllAdminViewState();
}

class _AllAdminViewState extends State<AllAdminView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('All Admin'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spaceBtwSection),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
            //   child: Text(
            //     'Departments',
            //     style: Theme.of(context).textTheme.titleMedium,
            //   ),
            // ),
            // 15.sH,
            // SizedBox(
            //   width: double.infinity,
            //   height: 45,
            //   child: ListView.builder(
            //     itemCount: 5,
            //     scrollDirection: Axis.horizontal,
            //     physics: const BouncingScrollPhysics(),
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.only(left: 10, right: 10),
            //         child: CupertinoButton(
            //           padding: EdgeInsets.zero,
            //           onPressed: () {
            //             setState(() {
            //               currentIndex = index;
            //             });
            //           },
            //           child: Card(
            //             margin: EdgeInsets.zero,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //                 side: BorderSide(
            //                     color: currentIndex == index ? Colors.transparent : AppColors.kwhite.withOpacity(0.4))),
            //             color: index == currentIndex ? AppColors.kPrimary : AppColors.kGrey.withOpacity(0.2),
            //             child: const Padding(
            //               padding: EdgeInsets.symmetric(horizontal: 20),
            //               child: Center(
            //                 child: Text('IOC'),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Container(
              height: 68,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.kSecondary,
                borderRadius: BorderRadius.circular(AppSizes.xl),
              ),
              child: TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  indicatorPadding: const EdgeInsets.all(10),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Text(
                        'Approved\nAdmins',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Pending\nAdmins',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
            ),
            20.sH,

            Expanded(
              child: TabBarView(
                children: [

                  AdminStatus(isApproved: true,),
                  AdminStatus(isApproved: false,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
