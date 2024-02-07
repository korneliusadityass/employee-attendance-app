import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../util/navhr.dart';
import '../../../core/colors/color.dart';
import '../../../core/model/approval/perjalanan_dinas/perjalanan_dinas_list_model.dart';
import '../../../core/routes/routes.dart';
import '../../appbar/custom_appbar_widget.dart';
import 'widgets/perjalanan_dinas_approval_controller.dart';

class ApprovalPerjalananDinas extends GetView<PerjalananDinasApprovalController> {
  ApprovalPerjalananDinas({super.key});
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();

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
  String? filterNama;
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataApprovalPerjalananDinas = [];

  Future<void> fetchData() async {
    controller.dataPerjalananDinas.value = await controller.execute(
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
            left: 20,
            right: 20,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Approval Perjalanan Dinas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 15,
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
                        Get.toNamed(Routes.needConfirmPerjalananDinas);
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
                        Get.toNamed(Routes.pageLogPerjalananDinas);
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
                  height: 15,
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
                          controller: tanggalAwalController,
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
                                  tanggalAwalController.text = '$hari/$bulan/$tahun';
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
                            contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
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
                  height: 15,
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
                          controller: tanggalAkhirController,
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
                                  tanggalAkhirController.text = '$hari/$bulan/$tahun';
                                  tglAkhir = '$tahun-$bulan-$hari';
                                  fetchData();
                                } catch (e) {
                                  null;
                                }
                              },
                            );
                          },
                          validator: endDateValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'tanggal',
                            fillColor: Colors.white24,
                            filled: true,
                            suffixIcon: const Icon(Icons.date_range_outlined),
                            contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
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
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 149,
                        child: GetBuilder<PerjalananDinasApprovalController>(builder: (controller) {
                          return DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
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
                              fetchData();
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 149,
                        height: 48,
                        child: GetBuilder<PerjalananDinasApprovalController>(builder: (controller) {
                          return DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
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
                  height: 15,
                ),
                Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => kGreenColor,
                        ),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'No',
                              style: TextStyle(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nama Karyawan',
                              style: TextStyle(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Judul Cuti Khusus',
                              style: TextStyle(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Durasi Cuti',
                              style: TextStyle(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jumlah Cuti',
                              style: TextStyle(
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(
                                color: kWhiteColor,
                              ),
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
                                controller.dataPerjalananDinas.length,
                                (int index) {
                                  int rowIndex = (page - 1) * pageSize + index + 1;
                                  ApprovalPerjalananDinasListModel data = controller.dataPerjalananDinas[index];
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(rowIndex.toString())),
                                      DataCell(Text(data.namaKaryawan)),
                                      DataCell(Text(data.judul)),
                                      DataCell(Text(
                                          '${DateFormat('dd/MM/yyyy').format(data.tanggalAwal)} - ${DateFormat('dd/MM/yyyy').format(data.tanggalAkhir)}')),
                                      DataCell(Text(data.jumlahHari.toString())),
                                      DataCell(Text(data.status)),
                                    ],
                                  );
                                },
                              ),
                      ),
                    )),
              ],
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
                    onPressed: controller.dataPerjalananDinas.length >= pageSize ? () => onPageChange(page + 1) : null,
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
