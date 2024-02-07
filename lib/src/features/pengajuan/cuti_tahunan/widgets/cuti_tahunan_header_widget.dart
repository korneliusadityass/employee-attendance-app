import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/cuti_tahunan_input_controller.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/sisa_kuota_cuti_tahunan_controller.dart';

import '../../../../core/colors/color.dart';
import '../../../../core/enums/sisa_kuota_enum.dart';

class PengajuanCutiTahunanHeaderWidget
    extends GetView<CutiTahunanListController> {
  PengajuanCutiTahunanHeaderWidget({super.key});

  final formkey = GlobalKey<FormState>();

  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  final sisaCutiController = Get.find<SisaKuotaController>();
  final pengajuanInputController = Get.find<InputCutitahunanController>();
  final TextEditingController judulCutiTahunanController =
      TextEditingController();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIa = '';
  String tanggalAPIb = '';

  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal!";
    }
    if (endData == null) return "pilih tanggal";
    if (endData!.isBefore(startDate!)) {
      return "tanggal akhir setelah tanggal awal";
    }

    return null; // optional while already return type is null
  }

  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round() + 1;

    return durasi;
  }

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;
  int currentYear = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cuti Tahunan',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        20.height,
        Container(
          width: 323,
          height: 63,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: kGreenColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FutureBuilder(
              future: sisaCutiController.getKuotaCutiTahunan(
                  kuotaCuti: SisaKuota.yearly),
                  
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Sisa Cuti Tahunan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor,
                            ),
                          ),
                          5.height,
                          const Text(
                            'Tahun ini',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      80.width,
                      Text(
                        '${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: kBlackColor,
                        
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
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
                fixedSize: const Size(160, 45),
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
                          key: formkey,
                          child: Container(
                            width: 320,
                            height: 384,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: FutureBuilder(
                                future: sisaCutiController.getKuotaCutiTahunan(
                                    kuotaCuti: SisaKuota.yearly),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'FORM PEMBUATAN CUTI TAHUNAN',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        10.height,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 250,
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      // height: 55,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                        child: Text(
                                                          'Sisa Cuti Tahunan',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    10.width,
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 16,
                                                      ),
                                                      child: Text(
                                                        '${snapshot.data}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              20.width
                                            ],
                                          ),
                                        ),
                                        10.height,
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Judul Cuti Tahunan',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        10.height,
                                        TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller:
                                              judulCutiTahunanController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Harus Diisi!!';
                                            }
                                            if (value.length > 30) {
                                              return 'maksimal 30 karakter!!!';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                // color: kBlackColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        10.height,
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 90,
                                                child: Column(
                                                  children: const [
                                                    SizedBox(
                                                      // height: 55,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                        child: Text(
                                                          'Tanggal Awal',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 90,
                                                child: Column(
                                                  children: const [
                                                    SizedBox(
                                                      // height: 55,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                        child: Text(
                                                          'Tanggal Akhir',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 28,
                                                child: Column(
                                                  children: const [
                                                    SizedBox(
                                                      // height: 55,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                        child: Text(
                                                          'Hari',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        StatefulBuilder(
                                          builder: (context, setState) => Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 35,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      tglAwalformController,
                                                  onTap: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ).then(
                                                      (value) {
                                                        try {
                                                          startDate = value;
                                                          var hari =
                                                              DateFormat.d()
                                                                  .format(
                                                                      value!);
                                                          var bulan =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var bulan2 =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var tahun =
                                                              DateFormat.y()
                                                                  .format(
                                                                      value);
                                                          tglAwalformController
                                                                  .text =
                                                              '$hari/$bulan/$tahun';
                                                          tanggalAPIa =
                                                              '$tahun-$bulan2-$hari';
                                                        } catch (e) {
                                                          null;
                                                        }
                                                      },
                                                    );
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: 'tanggal',
                                                    fillColor: Colors.white24,
                                                    filled: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 0, 5),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 100,
                                                height: 35,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      tglAkhirformController,
                                                  onTap: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ).then(
                                                      (value) {
                                                        try {
                                                          endData = value;

                                                          var hari =
                                                              DateFormat.d()
                                                                  .format(
                                                                      value!);
                                                          var bulan =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var bulan2 =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var tahun =
                                                              DateFormat.y()
                                                                  .format(
                                                                      value);
                                                          tglAkhirformController
                                                                  .text =
                                                              '$hari/$bulan/$tahun';
                                                          tanggalAPIb =
                                                              '$tahun-$bulan2-$hari';
                                                          final difference =
                                                              daysBetween(
                                                                  startDate!,
                                                                  endData!);
                                                          setState(() {});
                                                        } catch (e) {
                                                          null;
                                                        }
                                                      },
                                                    );
                                                  },
                                                  validator: endDateValidator,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    hintText: 'tanggal',
                                                    fillColor: Colors.white24,
                                                    filled: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 0, 5),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 50,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '$durasi',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 35,
                                            right: 35,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize:
                                                        const Size(84, 29),
                                                    backgroundColor:
                                                        kLightGrayColor,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize:
                                                        const Size(84, 29),
                                                    backgroundColor: kBlueColor,
                                                  ),
                                                  onPressed: () async {
                                                    await pengajuanInputController
                                                        .inputCutiTahuanPengajuan(
                                                      judulCutiTahunanController
                                                          .text,
                                                      tanggalAPIa,
                                                      tanggalAPIb,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Save',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: const Text(
                'Buat Cuti Tahunan',
                style: TextStyle(
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
