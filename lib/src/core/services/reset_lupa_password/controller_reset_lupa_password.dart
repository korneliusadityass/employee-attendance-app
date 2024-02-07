// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:project/src/core/services/lupa_password/services_lupa_password.dart';

// class LupaPasswordController extends GetxController {
//   LupaPasswordService service;
//   LupaPasswordController(this.service);

//   Future<void> getLupaPassword(String emailAddress, String token) async {
//     final result = await service.getResetLupaPassword(emailAddress, token);
//     result.fold(
//       (failure) => Get.snackbar('Error', failure.message),
//       (success) => Get.snackbar('Success', 'Password reset link has been sent to your email'),
//     );
//   }
// }
