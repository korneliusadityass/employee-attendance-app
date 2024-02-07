// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/detail_data_master_jumlah_cuti_tahunan_model.dart';

import '../../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/master/jumlah_cuti_tahunan/controller_detail_data_master_cuti_tahunan.dart';
import '../../../../core/model/master/jumlah_cuti_tahunan/controller_edit_master_cuti_tahunan.dart';
import '../../../appbar/custom_appbar_widget.dart';
import 'jumlah_cuti_tahunan.dart';

class EditMasterCutiTahunan extends StatefulWidget {
  const EditMasterCutiTahunan({super.key});

  @override
  State<EditMasterCutiTahunan> createState() => _EditMasterCutiTahunanState();
}

class _EditMasterCutiTahunanState extends State<EditMasterCutiTahunan> {
  final args = Get.arguments;
  final TextEditingController jumlahCutiController = TextEditingController();

  final masterjumlahcutitahunandetaildatacontroller =
      Get.find<DetailDataMasterCutiTahunan>();
  final masterjumlahcutitahunanEditcontroller =
      Get.find<MasterJumlahCutiTahunanEditController>();

  Map<String, dynamic> dataMasterCutiTahunan = {};
  final formKey = GlobalKey<FormState>();
  // TEST
  late Future<MasterCutiTahunanModel> _fetchDataMasterJumlahCutiTahunan;
  Future<void> generate() async {
    int jumlahCuti = int.parse(jumlahCutiController.text);
    debugPrint('ini jumlah cuti :$jumlahCuti');
    await masterjumlahcutitahunanEditcontroller.execute(
      args,
      jumlahCuti,
    );
  }

  // Future<Map<String, dynamic>> getData() async {
  //   final value1 = await _fetchDataMasterJumlahCutiTahunan;
  //   return {
  //     'value1': value1,
  //   };
  // }

  @override
  void initState() {
    super.initState();
    _fetchDataMasterJumlahCutiTahunan =
        masterjumlahcutitahunandetaildatacontroller.execute(args);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(dataMasterCutiTahunan.toString());
    debugPrint('hasil ${jumlahCutiController.text}');
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
        future: _fetchDataMasterJumlahCutiTahunan,
        builder: (context, snapshot) {
          jumlahCutiController.text =
              snapshot.data?.kuotaCutiTahunan.toString() ?? '';
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            // final hasil = snapshot.data!;
            MasterCutiTahunanModel? data = snapshot.data;

            debugPrint('Snapshot: ${snapshot.data}');

            debugPrint(jumlahCutiController.text);
            return Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                children: [
                  const Text(
                    'Edit Jumlah Cuti Tahunan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Jumlah Cuti',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: kBlackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      NumberInputWithIncrementDecrement(
                        controller: jumlahCutiController,
                        initialValue: int.parse(jumlahCutiController.text),
                        numberFieldDecoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                        ),
                        widgetContainerDecoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide.none,
                          ),
                        ),
                        incIconDecoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRedColor,
                          fixedSize: const Size(
                            90,
                            29,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 278,
                                  height: 270,
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
                                          color: Color(0xffFFF068),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Image.asset(
                                        'assets/warning logo.png',
                                        width: 80,
                                        height: 80,
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      const Text(
                                        'Apakah yakin ingin kembali\nhal yang anda edit tidak akan tersimpan ?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  const Color(0xff949494),
                                              fixedSize: const Size(100, 35.81),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 34,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  const Color(0xffFFF068),
                                              fixedSize: const Size(100, 35.81),
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      JumlahCutiTahunan(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Ya',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.cancel_outlined),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreenColor,
                          fixedSize: const Size(
                            90,
                            29,
                          ),
                        ),
                        onPressed: () {
                          generate();
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return Dialog(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //       child: Container(
                          //         width: 278,
                          //         height: 270,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(8),
                          //           color: Colors.white,
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             Container(
                          //               width: double.infinity,
                          //               height: 31,
                          //               decoration: const BoxDecoration(
                          //                 borderRadius: BorderRadius.vertical(
                          //                   top: Radius.circular(8),
                          //                 ),
                          //                 color: kDarkGreenColor,
                          //               ),
                          //             ),
                          //             const SizedBox(
                          //               height: 15,
                          //             ),
                          //             const Icon(
                          //               Icons.check_circle,
                          //               color: kGreenColor,
                          //               size: 80,
                          //             ),
                          //             const SizedBox(
                          //               height: 15,
                          //             ),
                          //             const Text(
                          //               'Jumlah Cuti Telah \nberhasil di ubah',
                          //               textAlign: TextAlign.center,
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w400,
                          //                 fontSize: 20,
                          //                 color: kBlackColor,
                          //               ),
                          //             ),
                          //             const SizedBox(
                          //               height: 24,
                          //             ),
                          //             ElevatedButton(
                          //               style: ElevatedButton.styleFrom(
                          //                 shape: RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.circular(8),
                          //                 ),
                          //                 backgroundColor: kDarkGreenColor,
                          //                 fixedSize: const Size(120, 45),
                          //               ),
                          //               onPressed: () {
                          //                 Navigator.pushReplacement(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         JumlahCutiTahunan(),
                          //                   ),
                          //                 );
                          //               },
                          //               child: const Text(
                          //                 'Oke',
                          //                 style: TextStyle(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 20,
                          //                   color: kWhiteColor,
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // );
                        },
                        child: const Icon(Icons.save),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
