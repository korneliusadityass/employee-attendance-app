import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/features/pengajuan_hr/cuti_tahunan/widget/hr_cuti_tahunan_list_controller.dart';

import '../../../../core/colors/color.dart';

class PengajuanCutiHrWidgetFilter extends StatefulWidget {
  PengajuanCutiHrWidgetFilter({super.key});

  @override
  State<PengajuanCutiHrWidgetFilter> createState() => _PengajuanCutiHrWidgetFilterState();
}

class _PengajuanCutiHrWidgetFilterState extends State<PengajuanCutiHrWidgetFilter> {
  final TextEditingController tglAwalController = TextEditingController();

  final TextEditingController tglAkhirController = TextEditingController();

  final controller = Get.find<CutiTahunanHrListController>();

  DateTime? endData;

  DateTime? startDate;

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

  // List<dynamic> cutiTahunanList = [];
  Future<void> fetchData() async {}

  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(
              width: 20,
            ),
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
        const SizedBox(
          height: 10,
        ),
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
        const SizedBox(
          height: 10,
        ),
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
                          chosevalue = value.toString();
                          chosevalue = value!;
                          controller.execute(filterStatus: chosevalue);
                          // fetchData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
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
                      chosevaluedua = value.toString();
                      chosevaluedua = value!;
                      pageSize = int.parse(chosevaluedua);
                      controller.execute(size: pageSize);
                      fetchData();
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
