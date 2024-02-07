import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/features/pengajuan_hr/izin_sakit/widget/hr_izin_sakit_list_controller.dart';

import '../../../../core/colors/color.dart';

String tglAwalFilter = '';
String tglAkhirFilter = '';

class HrPengajuanFilter extends StatefulWidget {
  const HrPengajuanFilter({super.key});

  @override
  State<HrPengajuanFilter> createState() => _HrPengajuanFilterState();
}

class _HrPengajuanFilterState extends State<HrPengajuanFilter> {
  final TextEditingController tglAwalController = TextEditingController();

  final TextEditingController tglAkhirController = TextEditingController();

  final controller = Get.find<HrIzinSakitListController>();

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

    return null;
  }

  var selectedItem = '';

  String chosevalue = 'All';

  String chosevaluedua = '10';

  String? tgllAwal;

  String? tgllAkhir;

  int pageSize = 10;

  int page = 1;

  bool isFetchingData = true;

  int currentYear = 0;

  Future<void> fetchData() async {
    controller.execute(
      page: page,
      tanggalAwal: tgllAwal,
      tanggalAkhir: tgllAkhir,
      filterStatus: chosevalue,
      size: controller.pageSize.value,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 149,
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
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: SizedBox(
                width: 149,
                height: 48,
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
                          tgllAwal = '$tahun-$bulan-$hari';
                          tglAwalFilter = tglAwalController.text;
                          controller.execute(tanggalAwal: tgllAwal);
                          fetchData();
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
                width: 149,
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
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: SizedBox(
                width: 149,
                height: 48,
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
                  validator: endDateValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          tgllAkhir = '$tahun-$bulan-$hari';
                          tglAkhirFilter = tglAkhirController.text;
                          controller.execute(tanggalAkhir: tgllAkhir);
                          fetchData();
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
                width: 149,
                // height: 55,
                child: GetBuilder<HrIzinSakitListController>(
                    builder: (controller) {
                  return DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kBlackColor)),
                      hintText: 'Status',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
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
                      controller.filterStatus2.value = chosevalue;
                      fetchData();
                    },
                  );
                }),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: SizedBox(
                width: 149,
                // height: 55,
                child: GetBuilder<HrIzinSakitListController>(
                    builder: (controller) {
                  return DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kBlackColor)),
                      hintText: 'Show',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
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
                      // pageSize = int.parse(chosevaluedua);
                      controller.pageSize.value = int.parse(chosevaluedua);
                      fetchData();
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
