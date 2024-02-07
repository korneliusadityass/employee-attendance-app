import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/util/navhr.dart';

import '../../../core/colors/color.dart';
import '../../../core/model/approval/izin_sakit/izin_sakit_list_model.dart';
import '../../../core/routes/routes.dart';
import '../../appbar/custom_appbar_widget.dart';
import 'widgets/izin_sakit_approval_controller.dart';

class ApprovalIzinSakit extends GetView<IzinSakitApprovalController> {
  ApprovalIzinSakit({super.key});

  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final formkey = GlobalKey<FormState>();

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
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> izinSakitList = [];

  Future<void> fetchData() async {
    controller.dataIzinSakit.value = await controller.execute(
      page: page,
      filterStatus: chosevalue,
      size: pageSize,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
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
              'Approval Izin Sakit',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0, left: 5),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: kBlueColor,
                        fixedSize: const Size(147, 23)),
                    onPressed: () {
                      Get.toNamed(Routes.needConfirmIzinSakit);
                    },
                    child: const Text(
                      'Need Confirm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: kBlueColor,
                        fixedSize: const Size(147, 23)),
                    onPressed: () {
                      Get.toNamed(Routes.pageLogIzinSakit);
                    },
                    child: const Text(
                      'Log',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
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
                SizedBox(
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
                          } catch (e) {
                            null;
                          }
                        },
                      );
                    },
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
                SizedBox(
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
                            fetchData();
                          } catch (e) {
                            null;
                          }
                        },
                      );
                    },
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
                    child: GetBuilder<IzinSakitApprovalController>(builder: (controller) {
                      return DropdownButtonFormField(
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
                    child: GetBuilder<IzinSakitApprovalController>(builder: (controller) {
                      return DropdownButtonFormField(
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
                          chosevaluedua = value!;
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
                            controller.dataIzinSakit.length,
                            (int index) {
                              // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                              int rowIndex = (page - 1) * pageSize + index + 1;
                              ApprovalIzinSakitListModel data = controller.dataIzinSakit[index];
                              return DataRow(
                                onLongPress: () {},
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
                    onPressed: controller.dataIzinSakit.length >= pageSize ? () => onPageChange(page + 1) : null,
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
