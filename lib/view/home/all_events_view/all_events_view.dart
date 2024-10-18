import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_sport_super_admin/utils/const/sizes.dart';
import 'package:uni_sport_super_admin/utils/widgets/custom_divider.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/const/image_string.dart';
import 'event_status.dart';

class AllEventsView extends StatefulWidget {
  const AllEventsView({super.key});

  @override
  State<AllEventsView> createState() => _AllEventsViewState();
}

class _AllEventsViewState extends State<AllEventsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Games Events'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spaceBtwSection),
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
                          'Approved\nEvents',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Pending\nEvents',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
              ),
              20.sH,
              Expanded(
                child: TabBarView(
                  children: [

                    EventsStatus(isApproved: true,),
                    EventsStatus(isApproved: false,),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
