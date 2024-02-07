import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../core/colors/color.dart';
import '../../core/routes/routes.dart';
import '../home/login/ganti_pw.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  StreamSubscription<PendingDynamicLinkData>? dynamicLink;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      dynamicLink?.cancel();
    } else {
      dynamicLink = FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
          final Uri deepLink = pendingDynamicLinkData.link;
          final token = deepLink.toString().split('?').last;
          final tokenLast = token.split('token=').last;
          debugPrint('ini link $deepLink');
          debugPrint('ini token $tokenLast');

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return GantiPw(token: tokenLast);
              },
            ));
          });
        },
      );
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    dynamicLink?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactiveForm(
        formGroup: controller.form,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            50.height,
            Image.asset(
              'assets/login.png',
              width: 200,
              height: 175,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
            ),
            10.height,
            const Text(
              'LOGIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: kGreenColor,
              ),
            ),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                5.height,
                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                8.height,
                ReactiveTextField(
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Email tidak boleh kosong',
                  },
                  formControlName: 'username',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fillColor: kWhiteColor,
                    filled: true,
                  ),
                ),
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    5.height,
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    8.height,
                    Obx(
                      () => ReactiveTextField(
                        validationMessages: {
                          ValidationMessage.required: (error) => 'Password tidak boleh kosong',
                        },
                        keyboardType: TextInputType.visiblePassword,
                        formControlName: 'password',
                        obscureText: controller.isVisible.value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isVisible.value ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.isVisible.toggle();
                            },
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Password',
                          hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          fillColor: kWhiteColor,
                          filled: true,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: kGreenColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () async {
                            await Get.toNamed(Routes.lupaPw);
                          },
                        ),
                      ],
                    ),
                    30.height,
                    Obx(
                      () {
                        if (controller.isLoading.value) {
                          return const SpinKitThreeBounce(
                            color: kGreenColor,
                            size: 20,
                          ).center();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              fixedSize: const Size(double.infinity, 38),
                              backgroundColor: kGreenColor),
                          onPressed: () {
                            controller.form.markAllAsTouched();
                            if (controller.form.valid) {
                              controller.login(
                                controller.form.control('username').value,
                                controller.form.control('password').value,
                              );
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
