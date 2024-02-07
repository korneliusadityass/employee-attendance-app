import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/core/model/approval/izin_3_jam/list_approval_izin_3_jam_model.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/approval/approval_izin_3_jam/widgets/list_izin_3_jam_approval_controller.dart';
import 'package:project/util/navhr.dart';

import '../../../core/colors/color.dart';
import '../../appbar/custom_appbar_widget.dart';

class ApprovalIzin3Jam extends GetView<ListIzin3JamApprovalController> {
  ApprovalIzin3Jam({super.key});

  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  final TextEditingController hariController = TextEditingController();
  DateTime? endData;
  DateTime? startDate;
  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal!";
    }
    if (startDate == null && endData != null) {
      return 'isi tanggal awal';
    }
    if (endData == null) return "pilih tanggal";
    if (endData!.isBefore(startDate!)) {
      return "tanggal akhir setelah tanggal awal";
    }

    return null;
  }

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  String? filterNama;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataIzin3Jam = [];

  Future fetchData() async {
    return controller.dataIzin3Jam.value = await controller.execute(
      page: page,
      filterStatus: chosevalue,
      size: pageSize,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    controller.pageNum.value = newPage;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
        future: controller.execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Center(
              child: SpinKitFadingFour(
                size: 20,
                color: Colors.amber,
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            chosevaluedua = controller.pageSize.value.toString();
            chosevalue = controller.filterStatus2.value;
            return RefreshIndicator(
              onRefresh: () async {
                await fetchData();
              },
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: 50,
                ),
                children: [
                  const Text(
                    'Approval Izin 3 Jam',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlueColor,
                          fixedSize: const Size(
                            147,
                            23,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.needConfirmIzin3Jam);
                        },
                        child: const Text(
                          'Need Confirm',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlueColor,
                          fixedSize: const Size(
                            147,
                            23,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.pageLogIzin3Jam);
                        },
                        child: const Text(
                          'Log',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: SizedBox(
                          width: 149,
                          child: Text(
                            'Tanggal Awal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 149,
                          height: 48,
                          child: TextFormField(
                            keyboardType: TextInputType.none,
                            controller: tglAwalController,
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
                                    tglAwalController.text =
                                        '$hari/$bulan/$tahun';
                                    tglAwal = '$tahun-$bulan-$hari';
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
                              suffixIcon: const Icon(Icons.date_range_outlined),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: SizedBox(
                          width: 149,
                          child: Text(
                            'Tanggal Akhir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 149,
                          height: 48,
                          child: TextFormField(
                            keyboardType: TextInputType.none,
                            controller: tglAkhirController,
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
                                    tglAkhirController.text =
                                        '$hari/$bulan/$tahun';
                                    tglAkhir = '$tahun-$bulan-$hari';
                                    fetchData();
                                  } catch (e) {
                                    null;
                                  }
                                },
                              );
                            },
                            validator: endDateValidator,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'tanggal',
                              fillColor: Colors.white24,
                              filled: true,
                              suffixIcon: const Icon(Icons.date_range_outlined),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  24.height,
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 149,
                          child: GetBuilder<ListIzin3JamApprovalController>(
                            builder: (controller) {
                              return DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  hintText: 'Status',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: kBlackColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kLightGrayColor,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: kWhiteColor,
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
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 149,
                          height: 48,
                          child: GetBuilder<ListIzin3JamApprovalController>(
                            builder: (controller) {
                              return DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  hintText: 'Show',
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: kBlackColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kLightGreenColor,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: kWhiteColor,
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
                                  pageSize = int.parse(chosevaluedua);
                                  controller.pageSize.value = pageSize;
                                  fetchData();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xff12EEB9)),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nama Karyawan',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Judul Izin 3 Jam',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tanggal Izin',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Durasi Izin',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        rows: controller.isFetchData.value
                            ? [
                                const DataRow(
                                  cells: [
                                    DataCell(CircularProgressIndicator()),
                                    DataCell(Text('Loading...')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                  ],
                                ),
                              ]
                            : List<DataRow>.generate(
                                controller.dataIzin3Jam.length,
                                (int index) {
                                  int rowIndex =
                                      (controller.pageNum.value - 1) *
                                              controller.pageSize.value +
                                          index +
                                          1;

                                  ListApprovalIzin3JamModel data =
                                      controller.dataIzin3Jam[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(rowIndex.toString())),
                                      DataCell(Text(data.namaKaryawan)),
                                      DataCell(Text(data.judul)),
                                      DataCell(Text(data.tanggalIjin
                                          .toString()
                                          .substring(0, 10))),
                                      DataCell(
                                        Text(
                                            '${data.waktuAwal.substring(0, 5)} - ${data.waktuAkhir.substring(0, 5)}'),
                                      ),
                                      DataCell(Text(data.status)),
                                    ],
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left),
                          onPressed: controller.pageNum.value > 1
                              ? () => onPageChange(controller.pageNum.value - 1)
                              : null,
                        ),
                        Container(
                            width: 30,
                            height: 30,
                            color: kBlueColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.pageNum.value}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_right),
                          onPressed: controller.dataIzin3Jam.length >=
                                  controller.pageSize.value
                              ? () => onPageChange(page + 1)
                              : null,
                        ),
                      ],
                    ),
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
