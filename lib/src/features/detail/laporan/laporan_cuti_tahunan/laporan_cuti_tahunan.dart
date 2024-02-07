import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/src/core/model/laporan/cuti_tahunan/list_laporan_cuti_tahunan_model.dart';
import 'package:project/src/features/detail/laporan/laporan_cuti_tahunan/widgets/laporan_cuti_tahunan_controller.dart';
import 'package:project/util/navhr.dart';

import '../../../../core/colors/color.dart';
import '../../../appbar/custom_appbar_widget.dart';

class LaporanCutiTahunan extends GetView<LaporanCutiTahunanController> {
  LaporanCutiTahunan({super.key});

//   @override
//   State<LaporanCutiTahunan> createState() => _LaporanCutiTahunanState();
// }

// class _LaporanCutiTahunanState extends State<LaporanCutiTahunan> {
  final args = Get.arguments;
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController searchKaryawanController =
      TextEditingController();

  // final controller = Get.find<LaporanCutiTahunanController>();
  final exportLaporanCutiTahunanController =
      Get.find<ExportLaporanCutiTahunanController>();
  DateTime? endDate;
  DateTime? startDate;
  String? endDateValidator(value) {
    // if (startDate != null && endDate == null) {
    //   return "pilih tanggal!";
    // }
    // if (startDate == null && endDate != null) {
    //   return 'isi tanggal awal';
    // }
    // if (endDate == null) return "pilih tanggal";
    if (startDate != null) {
      if (endDate!.isBefore(startDate!)) {
        return "tanggal akhir setelah tanggal awal";
      }
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
  // AREA TABLE CONTOH
  List<dynamic> dataCutiKhusus = [];
  List<dynamic> data = [];

  Future fetchData() async {
    return controller.dataLaporanCutiTahunan.value = await controller.execute(
      args,
      page: page,
      filterStatus: chosevalue,
      size: pageSize,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
      filterNama: filterNama,
    );
  }

  void onPageChange(int newPage) async {
    page = newPage;
    fetchData();
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    var formatter = DateFormat('d MMMM y', 'id');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    void downloadExcel() async {
      DateTime firstDayOfMonth;
      DateTime lastDayOfMonth;
      String firstDayOfYear;
      String lastDayOfYear;
      int year = DateTime.now().year;

      if (startDate == null && endDate == null) {
        firstDayOfMonth = DateTime(year, 1, 1);
        lastDayOfMonth = DateTime(year, 12, 31);
        firstDayOfYear = firstDayOfMonth.toString().substring(0, 10);
        lastDayOfYear = lastDayOfMonth.toString().substring(0, 10);
      } else if (startDate == null) {
        firstDayOfMonth = DateTime(year, 1, 1);
        firstDayOfYear = firstDayOfMonth.toString().substring(0, 10);
        lastDayOfMonth = endDate!;
        lastDayOfYear = lastDayOfMonth.toString().substring(0, 10);
      } else if (endDate == null) {
        firstDayOfMonth = startDate!;
        firstDayOfYear = firstDayOfMonth.toString().substring(0, 10);
        lastDayOfMonth = DateTime(year, 12, 31);
        lastDayOfYear = lastDayOfMonth.toString().substring(0, 10);
      } else {
        firstDayOfMonth = startDate!;
        lastDayOfMonth = endDate!;
        firstDayOfYear = firstDayOfMonth.toString().substring(0, 10);
        lastDayOfYear = lastDayOfMonth.toString().substring(0, 10);
      }

      String awalTanggal =
          formatDate(firstDayOfMonth.toString().substring(0, 10));
      String akhirTanggal =
          formatDate(lastDayOfMonth.toString().substring(0, 10));

      final hasil = await exportLaporanCutiTahunanController.exportLaporan(
        args,
        tanggalAwal: firstDayOfYear,
        filterNama: filterNama,
        tanggalAkhir: lastDayOfYear,
        filterStatus: chosevalue,
      );

      List<ListLaporanCutiTahunanModel> data = hasil;

      // Create Excel file and sheet
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];
      CellStyle cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        bold: true,
        textWrapping: TextWrapping.WrapText,
      );

      sheet.merge(
        CellIndex.indexByString('A1'),
        CellIndex.indexByString('H3'),
      );
      var cell1 = sheet.cell(CellIndex.indexByString('A1'));
      cell1.value =
          'Laporan Cuti Tahunan\nPT.GOLEK TRUK DOT COM\nTanggal : $awalTanggal - $akhirTanggal';
      cell1.cellStyle = cellStyle;

      sheet.appendRow([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ]);
      sheet.appendRow([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ]);

      // Add headers to sheet
      sheet.appendRow([
        'No',
        'Nama Karyawan',
        'Jabatan',
        'Judul Cuti',
        'Durasi Cuti',
        'Jumlah Hari',
        'Sisa Cuti',
        'Status'
      ]);

      // Add data to sheet
      var no = 1;
      for (var i = 0; i < data.length; i++) {
        var item = data[i];
        var durasiCuti =
            '${formatDate(item.tanggalAwal.toString())} - ${formatDate(item.tanggalAkhir.toString())}';
        sheet.appendRow([
          no.toString(),
          item.namaKaryawan,
          item.posisi,
          item.judul,
          durasiCuti,
          item.jumlahHari.toString(),
          item.sisaKuota.toString(),
          item.status,
        ]);
        no++;
      }

      // Save Excel file to device storage
      var bytes = excel.encode();
      final downloadDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create(recursive: true);
      }
      final file = File('${downloadDirectory.path}/LaporanCutiTahunan.xlsx');
      final downloaded = await file.writeAsBytes(bytes!, mode: FileMode.write);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    file.runtimeType == Null
                        ? 'Gagal mendapatkan akses penyimpanan'
                        : 'Telah berhasil diunduh ke folder Download',
                  ),
                  if (file.runtimeType != Null)
                    TextButton(
                      onPressed: () async {
                        try {
                          await OpenFilex.open(downloaded.path);
                        } catch (e) {
                          inspect(e);
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Buka'),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error Fetching Data');
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
                  left: 20,
                  right: 20,
                ),
                children: [
                  const Text(
                    'Laporan Cuti Tahunan',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: kBlackColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: searchKaryawanController,
                    onFieldSubmitted: (value) {
                      filterNama = searchKaryawanController.text;
                      fetchData();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Karyawan',
                      fillColor: Colors.white24,
                      filled: true,
                      suffixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Tanggal Awal',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
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
                                  tanggalAwalController.text =
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
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 50,
                          child: GetBuilder<LaporanCutiTahunanController>(
                            builder: (controller) {
                              return DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  hintText: 'Status',
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                value: chosevalue,
                                items: <String>[
                                  'All',
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
                                  controller.filterStatus2.value = chosevalue;
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
                    height: 10,
                  ),
                  const Text(
                    'Tanggal Akhir',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.none,
                              controller: tanggalAkhirController,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: startDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(
                                      (startDate ?? DateTime(2100)).year,
                                      12,
                                      31),
                                ).then(
                                  (value) {
                                    try {
                                      endDate = value;

                                      var hari = DateFormat.d().format(value!);
                                      var bulan = DateFormat.M().format(value);
                                      var tahun = DateFormat.y().format(value);
                                      tanggalAkhirController.text =
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
                                suffixIcon:
                                    const Icon(Icons.date_range_outlined),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: GetBuilder<LaporanCutiTahunanController>(
                                builder: (controller) {
                                  return DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 5),
                                      hintText: '10',
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    value: chosevaluedua,
                                    items: <String>[
                                      '10',
                                      '25',
                                      '50',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: kDarkGreenColor,
                              fixedSize: const Size(90, 45),
                            ),
                            onPressed: () async {
                              if (!Platform.isAndroid) return;

                              var status = await Permission.storage.request();

                              if (status.isPermanentlyDenied) {
                                var newStatus = await Permission
                                    .manageExternalStorage
                                    .request();
                                if (!newStatus.isRestricted) {
                                  status = newStatus;
                                }
                              }

                              if (status.isGranted) {
                                downloadExcel();
                              }

                              if (status.isPermanentlyDenied) {
                                if (context.mounted) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            width: 278,
                                            height: 270,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 31,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(8),
                                                    ),
                                                    color: kRedColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                const Icon(
                                                  Icons.warning_amber,
                                                  color: kRedColor,
                                                  size: 80,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                const Text(
                                                  'Tidak mendapatkan akses\nuntuk menulis file',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    backgroundColor: kRedColor,
                                                    fixedSize:
                                                        const Size(120, 45),
                                                  ),
                                                  onPressed: () {
                                                    openAppSettings();
                                                  },
                                                  child: const Text(
                                                    'Buka Setting',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20,
                                                      color: kWhiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }
                            },
                            child: const Text(
                              'Export',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ],
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
                        columns: const [
                          DataColumn(
                            label: Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nama Karyawan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jabatan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Judul Cuti',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Durasi Cuti',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jumlah Hari',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Sisa Cuti',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(color: Colors.white),
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
                                    DataCell(Text('')),
                                  ],
                                ),
                              ]
                            : List<DataRow>.generate(
                                controller.dataLaporanCutiTahunan.length,
                                (int index) {
                                  // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                                  int rowIndex =
                                      (page - 1) * pageSize + index + 1;
                                  ListLaporanCutiTahunanModel data =
                                      controller.dataLaporanCutiTahunan[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(rowIndex.toString())),
                                      DataCell(Text(data.namaKaryawan)),
                                      DataCell(Text(data.posisi)),
                                      DataCell(Text(data.judul)),
                                      DataCell(
                                        Text(
                                            '${data.tanggalAwal.toString().substring(0, 10)} - ${data.tanggalAkhir.toString().substring(0, 10)}'),
                                      ),
                                      DataCell(
                                          Text(data.jumlahHari.toString())),
                                      DataCell(Text(data.sisaKuota.toString())),
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
                          onPressed: controller.dataLaporanCutiTahunan.length >=
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
