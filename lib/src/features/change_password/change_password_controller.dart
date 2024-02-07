import 'package:get/get.dart';
import 'package:project/src/core/services/change_password_service.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordService changePasswordService;

  RxBool isVisible = true.obs;
  RxBool isVisible2 = true.obs;
  RxBool isVisible3 = true.obs;

  FormGroup form = FormGroup({
    'old_password': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(8),
      Validators.maxLength(20)
    ]),
    'new_password': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
        Validators.maxLength(20)
      ],
    ),
    'confirm_password': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
        Validators.maxLength(20)
      ],
      touched: false,
    ),
  }, validators: [
    Validators.mustMatch(
      'new_password',
      'confirm_password',
      markAsDirty: false,
    ),
  ]);

  ChangePasswordController(this.changePasswordService);

  RxBool isLoading = false.obs;

  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    isLoading.value = true;
    final response =
        await changePasswordService.changePassword(oldPassword, newPassword);
    isLoading.value = false;
    response.fold((l) {
      Get.snackbar('Error', l.message);
    }, (r) {
      Get.snackbar('Success', r);
      form.reset();
      Get.offAllNamed('/login');
    });
  }
}
