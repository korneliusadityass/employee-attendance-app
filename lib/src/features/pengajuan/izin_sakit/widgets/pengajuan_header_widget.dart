import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/extensions/extension.dart';

import '../../../../core/colors/color.dart';
import 'izin_sakit_input_controller.dart';

class PengajuanHeaderWidget extends GetView<InputIzinSakitController> {
  PengajuanHeaderWidget({super.key});

  final descController = TextEditingController();
  final firstDateController = TextEditingController();
  final lastDateController = TextEditingController();

  final pengajuanInputController = Get.find<InputIzinSakitController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Izin Sakit',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        20.height,
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: kBlueColor,
                fixedSize: const Size(150, 45),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'FORM PEMBUATAN IZIN SAKIT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                10.height,
                                const Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Judul Izin Sakit',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                10.height,
                                TextFormField(
                                  controller: descController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'harus diisi!!';
                                    }
                                    if (value.length > 30) {
                                      return 'maksimal 30 karakter!!!';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                10.height,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 90,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: Text(
                                                  'Tanggal Awal',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      90.width,
                                      const SizedBox(
                                        width: 90,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                child: Text(
                                                  'Tanggal Akhir',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.height,
                                StatefulBuilder(
                                  builder: (context, setState) => Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        height: 35,
                                        child: TextFormField(
                                          controller: firstDateController,
                                          keyboardType: TextInputType.none,
                                          onTap: () {
                                            DateTime now = DateTime.now();
                                            showDatePicker(
                                              context: context,
                                              initialDate: now,
                                              firstDate: now.subtract(
                                                const Duration(days: 365 * 5),
                                              ),
                                              lastDate: now.add(
                                                const Duration(days: 365 * 5),
                                              ),
                                            ).then(
                                              (value) {
                                                setState(() {
                                                  //value change to like that 2023-05-19

                                                  String formatDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(value!);
                                                  firstDateController.text =
                                                      formatDate;
                                                });
                                              },
                                            );
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'tanggal Awal',
                                            fillColor: Colors.white24,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 10, 0, 5),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      20.width,
                                      SizedBox(
                                        width: 130,
                                        height: 35,
                                        child: TextFormField(
                                          controller: lastDateController,
                                          keyboardType: TextInputType.none,
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            ).then(
                                              (value) {
                                                setState(() {
                                                  //value change to like that 2023-05-19

                                                  String formatDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(value!);
                                                  lastDateController.text =
                                                      formatDate;
                                                });
                                              },
                                            );
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            hintText: 'tanggal Akhir',
                                            fillColor: Colors.white24,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 10, 0, 5),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                20.height,
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 35,
                                    right: 35,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(84, 29),
                                            backgroundColor: kLightGrayColor,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Batal',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      40.width,
                                      SizedBox(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(84, 29),
                                            backgroundColor: kBlueColor,
                                          ),
                                          onPressed: () async {
                                            await pengajuanInputController
                                                .inputPengajuan(
                                                    descController.text,
                                                    firstDateController.text,
                                                    lastDateController.text);
                                          },
                                          child: const Text(
                                            'Save',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Buat Izin Sakit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
