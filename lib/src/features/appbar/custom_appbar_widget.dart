import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/colors/color.dart';
import '../change_password/change_password_page.dart';
import '../login/login_controller.dart';
import 'appbar_controller.dart';

class CustomAppBarWidget extends GetView<AppBarController>
    implements PreferredSizeWidget {
  CustomAppBarWidget({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: controller.obx(
        (state) => Align(
          alignment: Alignment.centerRight,
          child: Text(
            state!.namaKaryawan,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kWhiteColor,
            ),
          ),
        ),
        onLoading: const Align(
            alignment: Alignment.centerRight, child: Text('Loading...')),
        onError: (error) => Text('Error: $error'),
      ),
      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          itemBuilder: (_) {
            return [
              PopupMenuItem<String>(
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.zero,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.zero,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      loginController.logout();
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
        ),
      ],
      backgroundColor: const Color(0xff2B60C6),
    );
  }
}
