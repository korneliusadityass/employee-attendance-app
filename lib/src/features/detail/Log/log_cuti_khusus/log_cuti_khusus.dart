import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/approval/cuti_khusus/cuti_khusus_list_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../appbar/custom_appbar_widget.dart';
import '../../need_aprrove/need_confirm_cuti_khusus/widgets/need_confirm_cuti_khusus_controller.dart';
import 'widgets/log_cuti_khusus_controller.dart';

class LogCutiKhusus extends GetView<NeedConfirmCutiKhususController> {
  LogCutiKhusus({super.key});

  final TextEditingController searchKaryawanController = TextEditingController();
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
  String chosevalue3 = 'Refused,Cancelled,Approved';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  String? filterNama;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataLogCutiKhusus = [];

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
    return controller.dataCutiKhusus.value = await controller.execute(
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
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error Fetching Data');
          } else {
            return RefreshIndicator(
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
                    'Log Cuti Khusus',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                          child: GetBuilder<ListLogCutiKhususController>(builder: (controller) {
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
                                controller.filterStatus2.value = (value.toString());
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
                          child: GetBuilder<ListLogCutiKhususController>(builder: (controller) {
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
                                pageSize = int.parse(chosevaluedua);
                                controller.pageSize.value = pageSize;
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
                                  controller.dataCutiKhusus.length,
                                  (int index) {
                                    int rowIndex = (page - 1) * pageSize + index + 1;
                                    ApprovalCutiKhususListModel data = controller.dataCutiKhusus[index];
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
                                        DataCell(Text(data.jumlahHari.toString())),
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
                          onPressed: controller.dataCutiKhusus.length >= pageSize ? () => onPageChange(page + 1) : null,
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
