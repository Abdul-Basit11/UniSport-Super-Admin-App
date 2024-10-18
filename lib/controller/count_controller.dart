import 'package:get/get.dart';

import '../utils/const/back_end_config.dart';

class CountController extends GetxController {
  getCounts() async {
    var res = Future.wait([
      //0
      BackEndConfig.adminsCollection.where('isApproved', isEqualTo: true).get().then((value) {
        return value.docs.length;
      }),
      BackEndConfig.adminsCollection.where('isApproved', isEqualTo: false).get().then((value) {
        return value.docs.length;
      }),
      BackEndConfig.eventsCollection.where('isApproved', isEqualTo: true).get().then((value) {
        return value.docs.length;
      }),
      BackEndConfig.eventsCollection.where('isApproved', isEqualTo: false).get().then((value) {
        return value.docs.length;
      }),
      BackEndConfig.gamesCollection.get().then((value) {
        return value.docs.length;
      }),
      BackEndConfig.departmentCollection.get().then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }
}
