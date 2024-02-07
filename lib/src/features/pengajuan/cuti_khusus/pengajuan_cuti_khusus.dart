// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../util/drawerBuilder.dart';
import '../../../core/colors/color.dart';
import '../../../core/model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_list_model.dart';
import '../../../core/routes/routes.dart';
import '../../appbar/appbar_controller.dart';
import '../../appbar/custom_appbar_widget.dart';
import 'coachmark.dart';
import 'widgets/cuti_khusus_controller.dart';

class PengajuanCutiKhusus extends StatefulWidget {
  const PengajuanCutiKhusus({super.key});

  @override
  State<PengajuanCutiKhusus> createState() => _PengajuanCutiKhususState();
}

class _PengajuanCutiKhususState extends State<PengajuanCutiKhusus> {
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  bool firstTime = false;

  GlobalKey inputCuti = GlobalKey();
  GlobalKey filter = GlobalKey();
  GlobalKey table = GlobalKey();

  final TextEditingController judulcutiController = TextEditingController();
  final TextEditingController addtanggalAwalController =
      TextEditingController();
  final TextEditingController addtanggalAkhirController =
      TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final appbarController = Get.find<AppBarController>();
  final formkey = GlobalKey<FormState>();
  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIAwal = '';
  String tanggalAPIAkhir = '';

  final cutiKhususController = Get.find<CutiKhususController>();

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

  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    var duration = to.difference(from).inHours;
    var durasi = (duration / 24).floor() + 1;
    return durasi;
  }

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  Future<void> fetchData() async {
    cutiKhususController.dataCutiKhusus.value =
        await cutiKhususController.execute(
      page: page,
      filterStatus: chosevalue,
      size: pageSize,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    cutiKhususController.pageNum.value = newPage;
    fetchData();
  }

  Future hasSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result =
        prefs.getBool('hasSeenTutorialPengajuan Cuti Khusus') ?? false;
    return result;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      firstTime = await hasSeen();
      if (firstTime == false) {
        _showTutorialCoachmark();
      }
    });
  }

  void _showTutorialCoachmark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        pulseEnable: false,
        hideSkip: true,
        onClickTarget: (target) {},
        onSkip: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('hasSeenTutorialPengajuan Cuti Khusus', true);
        },
        onFinish: () {})
      ..show(context: context);
  }

  void _initTarget() {
    targets = [
      //input Cuti
      TargetFocus(
        identify: "inputCuti-Key",
        keyTarget: inputCuti,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Untuk membuat cuti",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "filter-Key",
        keyTarget: filter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "untuk filter",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "table-Key",
        keyTarget: table,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "untuk list tablenya",
                onNext: () {
                  setState(() async {
                    controller.next();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('hasSeenTutorialPengajuan Cuti Khusus', true);
                  });
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: DrawerBuilder(
        userMe: appbarController.fetchUserMe(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchData();
        },
        child: ListView(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 50,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cuti Khusus',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        6,
                      ),
                    ),
                    fixedSize: const Size(
                      190,
                      23,
                    ),
                    backgroundColor: kBlueColor,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Form(
                            key: formkey,
                            child: Container(
                              width: 320,
                              height: 320,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kWhiteColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      left: 11,
                                      right: 11,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          'Form Pembuatan Cuti Khusus',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 19,
                                        ),
                                        const Text(
                                          'Judul Cuti Khusus',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: kBlackColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: judulcutiController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Judul harus di isi';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  const BorderSide(width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            hintText: 'Judul Cuti Khusus',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        StatefulBuilder(
                                          builder: (context, setState) => Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Tanggal Awal',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 1,
                                                  ),
                                                  SizedBox(
                                                    width: 110,
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.none,
                                                      controller:
                                                          addtanggalAwalController,
                                                      onTap: () {
                                                        showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2000),
                                                          lastDate:
                                                              DateTime(2100),
                                                        ).then(
                                                          (value) {
                                                            try {
                                                              startDate = value;
                                                              var hari =
                                                                  DateFormat.d()
                                                                      .format(
                                                                          value!);
                                                              var bulan =
                                                                  DateFormat.M()
                                                                      .format(
                                                                          value);
                                                              var bulan2 =
                                                                  DateFormat.M()
                                                                      .format(
                                                                          value);
                                                              var tahun =
                                                                  DateFormat.y()
                                                                      .format(
                                                                          value);
                                                              addtanggalAwalController
                                                                      .text =
                                                                  '$hari/$bulan/$tahun';
                                                              tanggalAPIAwal =
                                                                  '$tahun-$bulan2-$hari';
                                                            } catch (e) {
                                                              null;
                                                            }
                                                          },
                                                        );
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'tanggal',
                                                        fillColor:
                                                            Colors.white24,
                                                        filled: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          borderSide:
                                                              const BorderSide(
                                                            width: 1,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 13,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Tanggal Akhir',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 1,
                                                  ),
                                                  SizedBox(
                                                    width: 110,
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.none,
                                                      controller:
                                                          addtanggalAkhirController,
                                                      onTap: () {
                                                        showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2000),
                                                          lastDate:
                                                              DateTime(2100),
                                                        ).then(
                                                          (value) {
                                                            try {
                                                              endData = value;

                                                              var hari =
                                                                  DateFormat.d()
                                                                      .format(
                                                                          value!);
                                                              var bulan =
                                                                  DateFormat.M()
                                                                      .format(
                                                                          value);
                                                              var bulan2 =
                                                                  DateFormat.M()
                                                                      .format(
                                                                          value);
                                                              var tahun =
                                                                  DateFormat.y()
                                                                      .format(
                                                                          value);
                                                              addtanggalAkhirController
                                                                      .text =
                                                                  '$hari/$bulan/$tahun';
                                                              tanggalAPIAkhir =
                                                                  '$tahun-$bulan2-$hari';
                                                              final difference =
                                                                  daysBetween(
                                                                      startDate!,
                                                                      endData!);
                                                              setState(() {
                                                                durasi =
                                                                    difference;
                                                              });
                                                            } catch (e) {
                                                              null;
                                                            }
                                                          },
                                                        );
                                                      },
                                                      validator:
                                                          endDateValidator,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'tanggal',
                                                        fillColor:
                                                            Colors.white24,
                                                        filled: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          borderSide:
                                                              const BorderSide(
                                                            width: 1,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 13,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Hari',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 1,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    height: 48,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '$durasi',
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    kLightGrayColor,
                                                fixedSize: const Size(90, 28),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: kWhiteColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 65,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kBlueColor,
                                                fixedSize: const Size(90, 28),
                                              ),
                                              onPressed: () async {
                                                if (formkey.currentState!
                                                    .validate()) {
                                                  final result =
                                                      await cutiKhususController
                                                          .inputCutiKhusus(
                                                    judulcutiController.text,
                                                    tanggalAPIAwal,
                                                    tanggalAPIAkhir,
                                                  );
                                                  print('INI ID : $result');
                                                  await Get.toNamed(
                                                      Routes.detailCutiKhusus,
                                                      arguments: result);
                                                }
                                              },
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: kWhiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    key: inputCuti,
                    children: const [
                      Icon(Icons.add),
                      SizedBox(
                        width: 11,
                      ),
                      Text(
                        'Buat Cuti Khusus',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  key: filter,
                  children: [
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
                                suffixIcon:
                                    const Icon(Icons.date_range_outlined),
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
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                hintText: 'Status',
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: kBlackColor)),
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
                              onChanged: (String? value) async {
                                chosevalue = value.toString();
                                chosevalue = value!;
                                fetchData();
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
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                hintText: 'Show',
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: kBlackColor)),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                Obx(
                  () => SingleChildScrollView(
                    key: table,
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
                            'Judul Cuti',
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
                            'Jumlah Hari',
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
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ],
                      rows: cutiKhususController.isFetchData.value
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
                              cutiKhususController.dataCutiKhusus.length,
                              (int index) {
                                int rowIndex =
                                    (page - 1) * pageSize + index + 1;
                                CutiKhususListModel data =
                                    cutiKhususController.dataCutiKhusus[index];
                                return DataRow(
                                  onLongPress: () async {
                                    await Get.toNamed(Routes.cutiKhususDetail,
                                        arguments: data.id);
                                  },
                                  cells: [
                                    DataCell(Text(rowIndex.toString())),
                                    DataCell(Text(data.judul)),
                                    DataCell(Text(
                                        '${DateFormat('dd/MM/yyyy').format(data.tanggalAwal)} - ${DateFormat('dd/MM/yyyy').format(data.tanggalAkhir)}')),
                                    DataCell(Text(data.jumlahHari.toString())),
                                    DataCell(Text(data.status)),
                                    data.status == 'Draft'
                                        ? DataCell(
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: kLightGrayColor,
                                                  ),
                                                  onPressed: () async {
                                                    // Navigate to another page with the id obtained from the API
                                                    await Get.toNamed(
                                                      Routes.cutiKhususEdit,
                                                      arguments: data.id,
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: kRedColor,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Container(
                                                            width: 278,
                                                            height: 270,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 31,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              8),
                                                                    ),
                                                                    color: Color(
                                                                        0xffFFF068),
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
                                                                  'Apakah anda yakin\nmenghapus pengajuan ini?',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 24,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        backgroundColor:
                                                                            const Color(0xff949494),
                                                                        fixedSize: const Size(
                                                                            100,
                                                                            35.81),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        // fetchData();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Cancel',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              kWhiteColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 34,
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        backgroundColor:
                                                                            const Color(0xffFFF068),
                                                                        fixedSize: const Size(
                                                                            100,
                                                                            35.81),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        await cutiKhususController
                                                                            .cutiKhususdelete(data.id);
                                                                        await fetchData();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Ya',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              kWhiteColor,
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
                                                ),
                                              ],
                                            ),
                                          )
                                        : data.status == 'Confirmed' ||
                                                data.status == 'Approved'
                                            ? DataCell(
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: kLightGrayColor,
                                                      ),
                                                      onPressed: () async {
                                                        // Navigate to another page with the id obtained from the API
                                                        await Get.toNamed(
                                                          Routes.cutiKhususEdit,
                                                          arguments: data.id,
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.cancel_outlined,
                                                        color: kRedColor,
                                                      ),
                                                      onPressed: () {
                                                        // Change the status of the data to 'Cancelled'
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Container(
                                                                width: 278,
                                                                height: 270,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          31,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              8),
                                                                        ),
                                                                        color: Color(
                                                                            0xffFFF068),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Image.asset(
                                                                      'assets/warning logo.png',
                                                                      width: 80,
                                                                      height:
                                                                          80,
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 7,
                                                                    ),
                                                                    const Text(
                                                                      'Apakah anda yakin\nmengcancel pengajuan ini?',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          24,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            backgroundColor:
                                                                                const Color(0xff949494),
                                                                            fixedSize:
                                                                                const Size(100, 35.81),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 18,
                                                                              color: kWhiteColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              34,
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            backgroundColor:
                                                                                const Color(0xffFFF068),
                                                                            fixedSize:
                                                                                const Size(100, 35.81),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                            await cutiKhususController.cutiKhususCancel(data.id);
                                                                            await fetchData();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Ya',
                                                                            style:
                                                                                TextStyle(
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
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : data.status == 'Refused' ||
                                                    data.status == 'Cancelled'
                                                ? DataCell(
                                                    // If status is "Refused" or "Cancelled", show an empty container instead of the IconButton
                                                    Container(),
                                                  )
                                                : DataCell(
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.arrow_forward),
                                                      onPressed: () async {
                                                        // Navigate to another page with the id obtained from the API
                                                        await Get.toNamed(
                                                          Routes.cutiKhususEdit,
                                                          arguments: data.id,
                                                        );
                                                      },
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
                        onPressed: cutiKhususController.pageNum.value > 1
                            ? () => onPageChange(
                                cutiKhususController.pageNum.value - 1)
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
                              '${cutiKhususController.pageNum.value}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: kWhiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_right),
                        onPressed: cutiKhususController.dataCutiKhusus.length >=
                                cutiKhususController.pageSize.value
                            ? () => onPageChange(page + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
