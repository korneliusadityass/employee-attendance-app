import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/src/core/services/lupa_password/controller_lupa_password.dart';
import 'package:project/src/features/login/login_page.dart';

import '../../../core/colors/color.dart';

class GantiPw extends StatefulWidget {
  const GantiPw({super.key, required this.token});

  final String token;

  @override
  State<GantiPw> createState() => _GantiPwState();
}

class _GantiPwState extends State<GantiPw> {
  bool isPassword = true;
  bool isPassword2 = true;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final controllerresetpassword = Get.find<LupaPasswordController>();

  @override
  Widget build(BuildContext context) {
//     if (_passwordController.text == _confirmpasswordController.text) {
// //berhasil
//     } else {
//       //gagal
//     }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 47,
            left: 48,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Lupa Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kGreenColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kBlackColor,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: _passwordController,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password wajib di isi';
                    } else if (value.length < 8 || value.length > 20) {
                      return 'minimal 8 karakter - maksimal 20 karakter';
                    } else if (value != _confirmpasswordController.text) {
                      // return null;
                      return 'Password harus sama';
                    }
                    return null;
                    // return 'Password harus sama';
                  },
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    hintText: 'Password baru',
                    hintStyle:
                        const TextStyle(color: kBlackColor, fontSize: 14),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isPassword = !isPassword;
                        setState(() {});
                      },
                      icon: const Icon(Icons.visibility),
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
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Konfirmasi Password baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kBlackColor,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: _confirmpasswordController,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Konfirmasi password wajib di isi';
                    } else if (value.length < 8 || value.length > 20) {
                      return 'minimal 8 karakter - maksimal 20 karakter';
                    } else if (value != _passwordController.text) {
                      // return null;
                      return 'Password harus sama';
                    }
                    return null;
                    // return 'Password harus sama';
                  },
                  obscureText: isPassword2,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    hintText: 'Konfirmasi',
                    hintStyle:
                        const TextStyle(color: kBlackColor, fontSize: 14),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isPassword2 = !isPassword2;
                        setState(() {});
                      },
                      icon: const Icon(Icons.visibility),
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
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    fixedSize: const Size(265, 43),
                    backgroundColor: kGreenColor,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (_passwordController.text ==
                          _confirmpasswordController.text) {
                        await controllerresetpassword.geResetLupaPassword(
                            widget.token, _passwordController.text);
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ));
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
