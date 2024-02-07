import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/approval/cuti_khusus/cuti_khusus_list_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../appbar/custom_appbar_widget.dart';
import 'widgets/need_confirm_cuti_khusus_controller.dart';

class NeedConfirmCutiKhusus extends GetView<NeedConfirmCutiKhususController> {
  NeedConfirmCutiKhusus({super.key});
  final TextEditingController searchKaryawanController = TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();

  final approvedRefuseCutiKhususController = Get.find<NeedConfirmCutiKhususController>();

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

  String chosevalue = 'Confirmed';
  String chosevaluedua = '10';
  String? filterNama;
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataNeedConfirmCutiKhusus = [];

  Future<void> fetchData() async {
    controller.dataCutiKhusus.value = await controller.execute(
      page: page,
      filterStatus: chosevalue,
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
              'Need Confirm Cuti Khusus',
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
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => SingleChildScrollView(
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
                    DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                                  Routes.detailNeedConfirmCutiKhusus,
                                  arguments: data.id,
                                );
                              },
                              cells: <DataCell>[
                                DataCell(Text(rowIndex.toString())),
                                DataCell(Text(data.namaKaryawan)),
                                DataCell(Text(data.judul)),
                                DataCell(Text(
                                    '${DateFormat('dd/MM/yyyy').format(data.tanggalAwal)} - ${DateFormat('dd/MM/yyyy').format(data.tanggalAkhir)}')),
                                DataCell(Text(data.jumlahHari.toString())),
                                DataCell(Text(data.status)),
                                DataCell(
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(108, 22),
                                          backgroundColor: kLightRedColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Container(
                                                  width: 278,
                                                  height: 270,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: 31,
                                                        decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(8),
                                                          ),
                                                          color: Color(0xffFFF068),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Image.asset(
                                                        'assets/warning logo.png',
                                                        width: 80,
                                                        height: 80,
                                                      ),
                                                      const SizedBox(
                                                        height: 7,
                                                      ),
                                                      const Text(
                                                        'Apakah anda yakin\nrefused pengajuan ini?',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              backgroundColor: const Color(0xff949494),
                                                              fixedSize: const Size(100, 35.81),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 18,
                                                                color: kWhiteColor,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 34,
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              backgroundColor: const Color(0xffFFF068),
                                                              fixedSize: const Size(100, 35.81),
                                                            ),
                                                            onPressed: () async {
                                                              Navigator.pop(context);
                                                              await approvedRefuseCutiKhususController
                                                                  .cutiKhususRefuse(data.id);
                                                            },
                                                            child: const Text(
                                                              'Ya',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 20,
                                                                color: kWhiteColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          'Refuse',
                                          style:
                                              TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kBlackColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(108, 22),
                                          backgroundColor: kLightGreenColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Container(
                                                  width: 278,
                                                  height: 270,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: 31,
                                                        decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(8),
                                                          ),
                                                          color: Color(0xffFFF068),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Image.asset(
                                                        'assets/warning logo.png',
                                                        width: 80,
                                                        height: 80,
                                                      ),
                                                      const SizedBox(
                                                        height: 7,
                                                      ),
                                                      const Text(
                                                        'Apakah anda yakin\nmenerima pengajuan ini?',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              backgroundColor: const Color(0xff949494),
                                                              fixedSize: const Size(100, 35.81),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 18,
                                                                color: kWhiteColor,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 34,
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              backgroundColor: const Color(0xffFFF068),
                                                              fixedSize: const Size(100, 35.81),
                                                            ),
                                                            onPressed: () async {
                                                              Navigator.pop(context);
                                                              await approvedRefuseCutiKhususController
                                                                  .cutiKhususApproved(data.id);
                                                            },
                                                            child: const Text(
                                                              'Ya',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 20,
                                                                color: kWhiteColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          'Approve',
                                          style:
                                              TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kBlackColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }
}
