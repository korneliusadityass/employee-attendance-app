import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/enums/duration_karyawan_enum.dart';
import 'package:project/src/core/model/user_me_model.dart';
import 'package:project/src/core/services/dashboard/dashboard_karyawan/dashboard_karyawan_controller.dart';
import 'package:project/util/navkaryawan.dart';

import '../../../core/colors/color.dart';
import '../../appbar/custom_appbar_widget.dart';
import '../../pengajuan/cuti_khusus/pengajuan_cuti_khusus.dart';
import '../../pengajuan/cuti_tahunan/pengajuan_cuti_tahunan.dart';
import '../../pengajuan/izin_3_jam/pengajuan_pembatalan_izin_3jam.dart';
import '../../pengajuan/izin_sakit/pengajuan_pembatalan_izin_sakit_page.dart';
import '../../pengajuan/perjalanan_dinas/pengajuan_perjalanan_dinas.dart';

class DashboarKaryawan extends GetView<DashboardKaryawanController> {
  DashboarKaryawan({super.key});

  String formattedDate =
      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavKaryawan(),
      body: SafeArea(
        child: FutureBuilder<UserMeModel?>(
          future: controller.getUser(),
          builder:
              (BuildContext context, AsyncSnapshot<UserMeModel?> snapshot) {
            String namaKaryawan = "";
            int perusahaanId = 0;
            if (snapshot.hasData) {
              namaKaryawan = snapshot.data!.namaKaryawan;
            }
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 16,
                right: 14,
              ),
              children: [
                Row(
                  children: [
                    const TextButton(
                      onPressed: null,
                      child: Text(
                        'Dashboard Karyawan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor,
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(
                      formattedDate.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 152,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/background.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 11,
                              left: 20,
                            ),
                            child: Text(
                              'Selamat Datang, $namaKaryawan !',
                              style: const TextStyle(
                                color: kWhiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Wrap(
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    100,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PengajuanCutiTahunan(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cuti Tahunan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    100,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PengajuanCutiKhusus(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cuti Khusus',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    100,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PengajuanIzin3Jam(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Izin 3 Jam',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    110,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PengajuanIzinSakitPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Izin Sakit',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    110,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PengajuanPerjalananDinas(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Perjalanan Dinas',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 160,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(18, 238, 185, 0.68),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 7,
                              top: 7,
                              bottom: 9,
                              right: 17,
                            ),
                            child: FutureBuilder<int?>(
                              future: controller.getSisaCutiTahunanKaryawan(
                                  duration: KaryawanDuration.yearly),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Sisa Cuti Tahunan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Tahun ini',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 160,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 194, 38, 0.58),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 7,
                              top: 7,
                              bottom: 9,
                              right: 17,
                            ),
                            child: FutureBuilder<int?>(
                              future: controller.getIzin3JamKaryawan(
                                  duration: KaryawanDuration.monthly),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Izin 3 Jam',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Bulan ini',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Total Request Karyawan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => kGreenColor,
                    ),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Tahun ini',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Cuti Tahunan'),
                          ),
                          DataCell(
                            FutureBuilder<int?>(
                              future: controller.getCutiTahunanKaryawan(
                                  duration: KaryawanDuration.yearly),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Cuti Khusus'),
                          ),
                          DataCell(
                            FutureBuilder<int?>(
                              future: controller.getCutiKhususKaryawan(
                                  duration: KaryawanDuration.yearly),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Izin 3 Jam'),
                          ),
                          DataCell(
                            FutureBuilder<int?>(
                              future: controller.getIzin3JamKaryawan(
                                  duration: KaryawanDuration.yearly),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Izin Sakit'),
                          ),
                          DataCell(
                            FutureBuilder<int?>(
                              future: controller.getIzinSakitKaryawan(
                                  duration: KaryawanDuration.yearly),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Perjalanan Dinas'),
                          ),
                          DataCell(
                            FutureBuilder<int?>(
                              future: controller.getPerjalananDinasKaryawan(
                                  duration: KaryawanDuration.yearly),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
