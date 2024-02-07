import 'package:get/get.dart';

import '../../../../core/services/login/login_service.dart';
import '../../../login/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      () => LoginController(Get.find(), Get.find()),
    );
    Get.put(
      () => LoginService(Get.find(), Get.find()),
    );
  }
}
