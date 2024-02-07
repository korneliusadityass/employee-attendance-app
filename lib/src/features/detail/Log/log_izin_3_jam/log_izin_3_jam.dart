import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/model/approval/izin_3_jam/list_approval_izin_3_jam_model.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/detail/Log/log_izin_3_jam/widgets/log_izin_3_jam_controller.dart';
import 'package:project/src/features/detail/need_aprrove/need_confirm_izin_3_jam/widgets/need_confirm_izin_3_jam_controller.dart';
import 'package:project/util/navhr.dart';

import '../../../../core/colors/color.dart';
import '../../../appbar/custom_appbar_widget.dart';

class LogIzin3jam extends GetView<NeedConfirmIzin3JamController> {
  LogIzin3jam({super.key});

  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController hariController = TextEditingController();
  final TextEditingController searchKaryawanController =
      TextEditingController();
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

  String chosevalue = 'All';
  String chosevalue3 = 'Refused,Cancelled,Approved';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  String? filterNama;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataIzin3Jam = [];

  void filter(value) async {
    try {
      if (value == 'All') {
        chosevalue = value;
        chosevalue3 = 'Refused,Cancelled,Approved';
      } else {
        chosevalue = value;
        chosevalue3 = chosevalue;
      }
      fetchData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future fetchData() async {
    return controller.dataIzin3Jam.value = await controller.execute(
      page: page,
      filterStatus: chosevalue3,
      size: pageSize,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
      filterNama: filterNama,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error Fetching Data');
          } else {
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
                    'Log Izin 3 Jam',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: searchKaryawanController,
                    onFieldSubmitted: (value) {
                      filterNama = searchKaryawanController.text;
                      fetchData();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Karyawan',
                      suffixIcon: const Icon(
                        Icons.search,
                        color: kBlackColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: kBlackColor,
                        ),
                      ),
                    ),
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
                                    fetchData();
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
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 149,
                          child: GetBuilder<ListLogIzin3JamController>(
                            builder: (controller) => DropdownButtonFormField(
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
                                controller.filterStatus2.value =
                                    (value.toString());
                                fetchData();
                              },
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
                          child: GetBuilder<ListLogIzin3JamController>(
                            builder: (controller) => DropdownButtonFormField(
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
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
                              'Tanggal izin ',
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
                                      (page - 1) * pageSize + index + 1;

                                  ListApprovalIzin3JamModel data =
                                      controller.dataIzin3Jam[index];
                                  return DataRow(
                                    onLongPress: () {
                                      Get.toNamed(
                                        Routes.detailLogIzin3Jam,
                                        arguments: data.id,
                                      );
                                    },
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
                          onPressed:
                              page > 1 ? () => onPageChange(page - 1) : null,
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
                                  '$page',
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
                          onPressed: controller.dataIzin3Jam.length >= pageSize
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
