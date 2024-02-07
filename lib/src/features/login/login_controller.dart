import 'package:get/get.dart';
import 'package:project/src/core/services/login/login_service.dart';
import 'package:project/src/features/home/dashboard/base_dashboard.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../core/helper/auth_pref_helper.dart';

class LoginController extends GetxController {
  AuthStorageHelper authHelper;
  LoginService loginService;
  LoginController(this.authHelper, this.loginService);

  RxBool isLoading = false.obs;

  final form = FormGroup({
    'username': FormControl<String>(
      validators: [Validators.required],
    ),
    'password': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
        Validators.maxLength(20)
      ],
    ),
  });

  ///Controller untuk menggunakan fungsi login
  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      final result = await loginService.login(username, password);
      result.fold((failure) {
        Get.snackbar('terjadi kesalahan', failure.message);
      }, (success) {
        Get.offAll(() => const BaseDashboard());
      });
    } catch (e) {
      Get.snackbar('terjadi kesalahan', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  ///Controller untuk melakukan logout
  Future<void> logout() async {
    loginService.logout();
  }

  RxBool isVisible = true.obs;
}
