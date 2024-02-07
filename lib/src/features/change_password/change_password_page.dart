import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../core/colors/color.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactiveForm(
        formGroup: controller.form,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            100.height,
            const Text(
              'CHANGE PASSWORD',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kGreenColor,
              ),
            ),
            50.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Password Lama',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.height,
                Obx(
                  () => ReactiveTextField(
                    obscureText: controller.isVisible.value,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    formControlName: 'old_password',
                    validationMessages: {
                      ValidationMessage.required: (error) =>
                          'Password tidak boleh kosong',
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.isVisible.toggle();
                        },
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Password Lama',
                      hintStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                16.height,
                const Text(
                  'Password Baru',
                  style: TextStyle(
                    color: kBlackColor,
                  ),
                ),
                8.height,
                Obx(
                  () => ReactiveTextField(
                    obscureText: controller.isVisible2.value,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    validationMessages: {
                      ValidationMessage.required: (error) =>
                          'Password tidak boleh kosong',
                    },
                    formControlName: 'new_password',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      hintText: 'Password Baru',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isVisible2.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.isVisible2.toggle();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: kBlackColor,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                16.height,
                const Text(
                  'Konfirmasi Password baru',
                  style: TextStyle(
                    color: kBlackColor,
                  ),
                ),
                8.height,
                Obx(
                  () => ReactiveTextField(
                    obscureText: controller.isVisible3.value,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validationMessages: {
                      ValidationMessage.required: (error) =>
                          'Password tidak boleh kosong',
                      ValidationMessage.mustMatch: (error) =>
                          'Password tidak sama',
                    },
                    formControlName: 'confirm_password',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      hintText: 'Konfirmasi',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isVisible3.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          controller.isVisible3.toggle();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: kBlackColor,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                50.height,
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SpinKitThreeBounce(
                      color: kGreenColor,
                      size: 20,
                    ).center();
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      fixedSize: const Size(255, 50),
                      backgroundColor: kGreenColor,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      controller.form.markAllAsTouched();
                      if (controller.form.valid) {
                        controller.changePassword(
                          newPassword:
                              controller.form.control('new_password').value,
                          oldPassword:
                              controller.form.control('old_password').value,
                        );
                      }
                    },
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
