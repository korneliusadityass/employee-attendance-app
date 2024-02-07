import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import '.../color.dart';
// import '.../util/navbar.dart';
import 'package:project/util/navhr.dart';

import '../../../../core/colors/color.dart';
import '../../../../core/model/approval/cuti_tahunan/cuti_tahunan_list_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../appbar/custom_appbar_widget.dart';
import '../../need_aprrove/need_confirm_cuti_tahunan/widgets/need_confirm_cuti_tahunan_controller.dart';
import '../detail_log/detail_log_cuti_tahunan.dart';
import 'widgets/log_cuti_tahunan_controller.dart';

class LogCutiTahunan extends GetView<NeedConfirmCutiTahunanController> {
  LogCutiTahunan({super.key});
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController hariController = TextEditingController();

  final TextEditingController searchKaryawanController = TextEditingController();
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
  String chosevalue3 = 'Refused,Cancelled,Approved';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  String? filterNama;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> cutiTahunanList = [];

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
      print(e);
    }
  }

  Future<void> fetchData() async {
    controller.dataCutiTahunan.value = await controller.execute(
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
      body: RefreshIndicator(
        onRefresh: () async {
          fetchData();
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
              'Log Cuti Tahunan',
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
              height: 15,
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
                              tglAwal = '$tahun-$bulan-$hari';
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
                              tglAkhir = '$tahun-$bulan-$hari';
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
                    child: GetBuilder<ListLogCutiTahunanController>(builder: (controller) {
                      return DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: kBlackColor)),
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
                          filter(value.toString());
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
                    child: GetBuilder<ListLogCutiTahunanController>(builder: (controller) {
                      return DropdownButtonFormField(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: kBlackColor)),
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
                          pageSize = int.parse(chosevaluedua);
                          fetchData();
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => const Color(0xff12EEB9)),
                    columns: const [
                      DataColumn(
                          label: Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                      DataColumn(
                          label: Text(
                        'Nama Karyawan',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                      DataColumn(
                          label: Text(
                        'Judul Izin Sakit',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                      DataColumn(
                          label: Text(
                        'Tanggal Izin',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                      DataColumn(
                          label: Text(
                        'Status',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
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
                              ],
                            ),
                          ]
                        : List<DataRow>.generate(
                            controller.dataCutiTahunan.length,
                            (int index) {
                              int rowIndex = (page - 1) * pageSize + index + 1;
                              ApprovalCutiTahunanListModel data = controller.dataCutiTahunan[index];
                              return DataRow(
                                onLongPress: () {
                                  Get.toNamed(
                                    Routes.detailLogCutiKhusus,
                                    arguments: data.id,
                                  );
                                },
                                cells: [
                                  DataCell(Text(rowIndex.toString())),
                                  DataCell(Text(data.namaKaryawan)),
                                  DataCell(Text(data.judul)),
                                  DataCell(Text(
                                      '${DateFormat('dd/MM/yyyy').format(data.tanggalAwal)} - ${DateFormat('dd/MM/yyyy').format(data.tanggalAkhir)}')),
                                  DataCell(Text(data.status)),
                                ],
                              );
                            },
                          ),
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left),
                    onPressed: page > 1 ? () => onPageChange(page - 1) : null,
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
                    onPressed: controller.dataCutiTahunan.length >= pageSize ? () => onPageChange(page + 1) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
