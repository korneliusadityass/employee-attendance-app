import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/extensions/extension.dart';

import '../../../../core/colors/color.dart';
import 'cuti_tahunan_controller.dart';

String tglAwalFilterCuti = '';
String tglAkhirFilterCuti = '';

class PengajuanFilterWidgetCutiTahunan
    extends GetView<CutiTahunanListController> {
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();

  DateTime? endData;
  DateTime? startDate;
  PengajuanFilterWidgetCutiTahunan({super.key});

  // get controller => null;

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

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;
  int currentYear = 0;

  // List<dynamic> cutiTahunanList = [];

  Future<void> fetchData() async {
    // controller.cutiTahunanList.value = await controller.execute(
    //   page: page,
    //   size: pageSize,
    //   filterStatus: chosevalue,
    //   tanggalAwal: tglAwal,
    //   tanggalAkhir: tglAkhir,
    // );
    //   // setState(() {
    //     isFetchingData = true;
    //   // });
    //   final result = await CutiTahunanListServices().fetchCutiTahunan(
    //     page: page,
    //     tanggalAwal: tglAwal,
    //     tanggalAkhir: tglAkhir,
    //     filterStatus: chosevalue,
    //     size: pageSize,
    //   );
    //   if (result != null && result is List<dynamic>) {
    //     // setState(() {
    //       cutiTahunanList = result;
    //     // });
    //   } else {
    //     debugPrint('Error fetching data');
    //   }

    //   setState(() {
    //     isFetchingData = false;
    //   });
    //   DateTime now = DateTime.now();
    //   currentYear = now.year;
  }

  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 145,
              child: Column(
                children: const [
                  SizedBox(
                    height: 55,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        'Tanggal Awal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.width,
            Expanded(
              child: SizedBox(
                width: 155,
                height: 55,
                child: TextFormField(
                  controller: tglAwalController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    hintText: 'tanggal awal',
                    fillColor: Colors.white24,
                    filled: true,
                    suffixIcon: const Icon(Icons.date_range_outlined),
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 1,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then(
                      (value) {
                        try {
                          startDate = value;
                          var hari = DateFormat.d().format(value!);
                          var bulan = DateFormat.M().format(value);
                          var tahun = DateFormat.y().format(value);
                          tglAwalController.text = '$hari/$bulan/$tahun';
                          tglAwal = '$tahun-$bulan-$hari';
                          tglAwalFilterCuti = tglAwalController.text;
                          controller.execute(tanggalAwal: tglAwal);
                          // fetchData();
                        } catch (e) {
                          null;
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        10.height,
        Row(
          children: [
            SizedBox(
              width: 145,
              child: Column(
                children: const [
                  SizedBox(
                    height: 55,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        'Tanggal akhir',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.width,
            Expanded(
              child: SizedBox(
                width: 155,
                height: 55,
                child: TextFormField(
                  controller: tglAkhirController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    hintText: 'tanggal akhir',
                    fillColor: Colors.white24,
                    filled: true,
                    suffixIcon: const Icon(Icons.date_range_outlined),
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 1,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then(
                      (value) {
                        try {
                          endData = value;

                          var hari = DateFormat.d().format(value!);
                          var bulan = DateFormat.M().format(value);

                          var tahun = DateFormat.y().format(value);
                          tglAkhirController.text = '$hari/$bulan/$tahun';
                          tglAkhir = '$tahun-$bulan-$hari';
                          tglAkhirFilterCuti = tglAkhirController.text;
                          controller.execute(tanggalAkhir: tglAkhir);
                          // fetchData();
                        } catch (e) {
                          null;
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        10.height,
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 155,
                height: 55,
                child: Column(
                  children: [
                    SizedBox(
                      height: 55,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          hintText: 'Status',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor,
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kBlackColor)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kBlackColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: kBlackColor,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        value: chosevalue,
                        items: <String>[
                          'All',
                          'Draft',
                          'Confirmed',
                          'Approved',
                          'Refused',
                          'Cancelled',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // setState(
                          //   () {
                          chosevalue = value.toString();
                          chosevalue = value!;
                          controller.execute(filterStatus: chosevalue);
                          //     // fetchData();
                          //   },
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            10.width,
            Expanded(
              child: SizedBox(
                width: 155,
                height: 55,
                child: SizedBox(
                  height: 55,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'show',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kBlackColor)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kBlackColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: kBlackColor,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    value: chosevaluedua,
                    items: <String>[
                      '10',
                      '20',
                      '50',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // setState(
                      //   () {
                      chosevaluedua = value.toString();
                      chosevaluedua = value!;
                      pageSize = int.parse(chosevaluedua);
                      controller.execute(size: pageSize);
                      fetchData();
                      //   },
                      // );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
