import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/services/lupa_password/controller_lupa_password.dart';

import '../../../core/colors/color.dart';

class LupaPw extends GetView<LupaPasswordController> {
  LupaPw({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool sudahdiisi = false;
  String email = '';

  Future<void> kirimEmail() async {
    try {
      print('EMAILLLL : $email');
      await controller.getLupaPassword(email);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 150,
            left: 20,
            right: 20,
          ),
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Lupa Password',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: kGreenColor,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              textAlign: TextAlign.center,
              'Masukan email yang anda gunakan ketika mendaftar dan kita akan mengirimkan petunjuk untuk mengganti password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kDarkGrayColor,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email harus diisi';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Email harus mengandung "@" dan "."';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.contains('@') && value.contains('.')) {
                          sudahdiisi = true;
                          email = emailController.text;
                          print(email);
                        } else {
                          sudahdiisi = false;
                        }
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail,
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: kDarkGrayColor,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: kLightGreenColor,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        fillColor: kWhiteColor,
                        filled: true,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: kGreenColor,
                        fixedSize: const Size(335, 44),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          kirimEmail();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 278,
                                  height: 310,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 31,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(8),
                                          ),
                                          color: kDarkGreenColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Icon(
                                        Icons.check_circle,
                                        color: kGreenColor,
                                        size: 80,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text(
                                        'Pesan email telah dikirim ke email anda',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: kBlackColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Bila belum menerima klik',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: kBlackColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () =>
                                                kirimEmail().then((value) {
                                              Navigator.pop(context);
                                            }),
                                            child: const Text(
                                              'kirim lagi',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: kGreenColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          backgroundColor: kDarkGreenColor,
                                          fixedSize: const Size(120, 43),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         const GantiPw(token: '',),
                                          //   ),
                                          // );
                                        },
                                        child: const Text(
                                          'Oke',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: kWhiteColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },

                      /// untuk syarat
                      // onPressed: sudahdiisi
                      //     ? () {
                      //         if (formKey.currentState!.validate()) {
                      //         }
                      //         // Navigator.push(
                      //         //   context,
                      //         //   MaterialPageRoute(
                      //         //     builder: (context) => const GantiPw(),
                      //         //     // untuk Register yg benar
                      //         //   ),
                      //         // );
                      //       }
                      //     : null,
                      child: const Text(
                        'Kirim',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
