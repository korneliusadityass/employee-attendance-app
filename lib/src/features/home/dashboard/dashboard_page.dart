import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/enums/duration_enum.dart';
import 'package:project/src/core/model/user_me_model.dart';
import 'package:project/src/core/services/dashboard/dashboard_hr/dashboardhr_controler.dart';
import 'package:project/src/features/home/dashboard/dashboard_saya.dart';
import 'package:project/util/navhr.dart';

import '../../../core/colors/color.dart';
import '../../appbar/custom_appbar_widget.dart';

class DashboardPage extends GetView<DashboardHrController> {
  DashboardPage({super.key});

  String formattedDate =
      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.now());

  // final jumlahKaryawanService = JumlahKaryawanService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder<UserMeModel?>(
        future: controller.getUser(),
        builder: (BuildContext context, AsyncSnapshot<UserMeModel?> snapshot) {
          String namaKaryawan = "";
          int perusahaanId = 0;
          if (snapshot.hasData) {
            namaKaryawan = snapshot.data!.namaKaryawan;
            // perusahaanId = snapshot.data!.id;
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardSaya(),
                        ),
                      );
                    },
                    child: const Text(
                      'Dashboard User',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor,
                        decoration: TextDecoration.underline,
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
                  color: kBlueColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 19,
                        top: 20,
                        right: 25,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang,',
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '$namaKaryawan !',
                                style: const TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Image.asset(
                            'assets/admin.png',
                            width: 77,
                            height: 108,
                          )
                        ],
                      ),
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
                        width: 158,
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
                            future: controller.getTotalKaryawanHr(),
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
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Karyawan',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'All Company',
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
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: 158,
                        height: 73,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 38, 168, 0.48),
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
                            future: controller.getTotalCutiKhusus(
                                duration: HRDuration.monthly),
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
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Cuti Khusus',
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
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: 158,
                        height: 73,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(118, 24, 176, 0.39),
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
                            future: controller.getTotalIzin3Jam(
                                duration: HRDuration.monthly),
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
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Izin 3 Jam',
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
                  const Spacer(
                    flex: 1,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 158,
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
                            future: controller.getTotalCutiTahunan(
                                duration: HRDuration.monthly),
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
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Cuti Tahunan',
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
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: 158,
                        height: 73,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(18, 80, 238, 0.37),
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
                            future: controller.getTotalIzinSakit(
                                duration: HRDuration.monthly),
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
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Izin Sakit',
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
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: 158,
                        height: 73,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 129, 38, 0.64),
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
                            future: controller.getTotalDinas(
                                duration: HRDuration.monthly),
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
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Dinas',
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
                'Total Request Tahunan',
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
                            future: controller.getTotalCutiTahunan(
                                duration: HRDuration.yearly),
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
                            future: controller.getTotalCutiKhusus(
                                duration: HRDuration.yearly),
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
                          Text('Izin 3 jam'),
                        ),
                        DataCell(
                          FutureBuilder<int?>(
                            future: controller.getTotalIzin3Jam(
                                duration: HRDuration.yearly),
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
                          Text('Izin sakit'),
                        ),
                        DataCell(
                          FutureBuilder<int?>(
                            future: controller.getTotalIzinSakit(
                                duration: HRDuration.yearly),
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
                            future: controller.getTotalDinas(
                                duration: HRDuration.yearly),
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
    );
  }
}
