import 'package:get/get.dart';
import 'package:project/src/core/services/appbar/appbar_service.dart';

import '../../core/model/user_me_model.dart';

class AppBarController extends GetxController with StateMixin<UserMeModel> {
  AppbarService appbarService;
  AppBarController(this.appbarService);

  Future<UserMeModel> fetchUserMe() async {
    return await appbarService.fetchUserMe();
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserMe().then((value) {
      change(value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    });
  }
}
