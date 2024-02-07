import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_3_jam/widgets/detail_izin_3_jam_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../util/drawerBuilder.dart';
import '../../../core/colors/color.dart';
import '../../../core/model/pengajuan_pembatalan/izin_3_jam_model/list_izin_3_jam_model.dart';
import '../../../core/routes/routes.dart';
import '../../appbar/appbar_controller.dart';
import '../../appbar/custom_appbar_widget.dart';
import 'widgets/pengajuan_izin_3_jam_controller.dart';

String judulIzin3Jam = '';
String durasiWaktuMulai = '';
String durasiWaktuSelesai = '';
String tanggalIzin3Jam = '';

class PengajuanIzin3Jam extends StatefulWidget {
  const PengajuanIzin3Jam({super.key});

  @override
  State<PengajuanIzin3Jam> createState() => _PengajuanIzin3JamState();
}

class _PengajuanIzin3JamState extends State<PengajuanIzin3Jam> {
  final TextEditingController tglAwalController = TextEditingController();

  final TextEditingController tglAkhirController = TextEditingController();

  final TextEditingController tglFormController = TextEditingController();

  final TextEditingController startDurasiIzinController =
      TextEditingController();

  final TextEditingController endDurasiIzinController = TextEditingController();

  final TextEditingController judulIzinController = TextEditingController();

  final TextEditingController hariController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  final appbarController = Get.find<AppBarController>();

  final formkey = GlobalKey<FormState>();

  DateTime? endData;

  DateTime? startDate;

  String tanggalAPI = '';

  DateTime? date;

  final controller = Get.find<Izin3JamListController>();

  final pengajuanIzin3JamController = Get.find<PengajuanIzin3JamController>();

  final cancelPengajuanIzin3JamController =
      Get.find<CancelPengajuanIzin3JamController>();

  final deletePengajuanIzin3JamController =
      Get.find<DeleteIzin3JamController>();

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

  TimeOfDay _startTime = const TimeOfDay(hour: 00, minute: 00);

  TimeOfDay _endTime = const TimeOfDay(hour: 00, minute: 00);

  TimeOfDay? startWaktu;

  TimeOfDay? endWaktu;

  String? startHour;

  String? endHour;

  void _selectStartTime(context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (newTime != null) {
      _startTime = newTime;
      var jam = _startTime.hour;
      var menit = _startTime.minute;
      var hasilMenit = '';
      var hasilJam = '';
      if (jam < 10) {
        hasilJam = '0$jam';
      } else {
        hasilJam = jam.toString();
      }
      if (menit < 10) {
        hasilMenit = '0$menit';
      } else {
        hasilMenit = menit.toString();
      }

      startWaktu = _startTime;
      // startHour = DateTime(date!.year, date!.month, date!.day, _startTime.hour,
      //         _startTime.minute)
      //     .toIso8601String();

      startDurasiIzinController.text = '$hasilJam:$hasilMenit';
    }
  }

  void _selectEndTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (newTime != null) {
      _endTime = newTime;
      var jam = _endTime.hour;
      var menit = _endTime.minute;
      var hasilMenit = '';
      var hasilJam = '';
      if (jam < 10) {
        hasilJam = '0$jam';
      } else {
        hasilJam = jam.toString();
      }
      if (menit < 10) {
        hasilMenit = '0$menit';
      } else {
        hasilMenit = menit.toString();
      }
      endWaktu = _endTime;
      // endHour = DateTime(date!.year, date!.month, date!.day, _endTime.hour,
      //         _endTime.minute)
      //     .toIso8601String();
      endDurasiIzinController.text = '$hasilJam:$hasilMenit';
    }
  }

  int getMinutesDiff(TimeOfDay tod1, TimeOfDay tod2) {
    return (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
  }

  String? startTimeValidator(value) {
    if (startWaktu == null) {
      Get.snackbar('Error', 'Waktu awal wajib di isi',
          backgroundColor: kWhiteColor);
      return 'waktu awal wajib di isi';
    }
    return null;
  }

  String? endTimeValidator(value) {
    if (endWaktu == null) {
      return "pilih waktu akhir";
    } else if (endWaktu != null && startWaktu != null) {
      int beda = getMinutesDiff(startWaktu!, endWaktu!).abs();
      int startMinute = startWaktu!.hour * 60 + startWaktu!.minute;
      int endMinute = endWaktu!.hour * 60 + endWaktu!.minute;
      if (startMinute > endMinute) {
        return 'waktu awal harus lebih kecil dari waktu akhir';
      }
      if (beda > 180) {
        return 'izin maksimal 3 jam!';
      }
    }
    return null;
  }

  String chosevalue = 'All';

  String chosevaluedua = '10';

  String? tglAwal;

  String? tglAkhir;

  int pageSize = 10;

  int page = 1;

  // AREA TABLE CONTOH
  List<dynamic> dataIzin3Jam = [];

  Future fetchData() async {
    return controller.dataIzin3Jam.value = await controller.execute(
      page: page,
      filterStatus: chosevalue,
      size: pageSize,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
    );
  }

  void onPageChange(int newPage) async {
    page = newPage;
    controller.pageNum.value = newPage;
    fetchData();
  }

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  bool seeTutorial = false;

  GlobalKey createKey = GlobalKey();
  GlobalKey filterKey = GlobalKey();
  GlobalKey tableKey = GlobalKey();

  Future hasSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool('hasSeenTutorialPengajuanIzin3Jam') ?? false;
    return result;
  }

  void _showTutorialCoachmark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        pulseEnable: false,
        hideSkip: true,
        onClickTarget: (target) {
          debugPrint('${target.identify}');
        },
        onSkip: () async {
          debugPrint("SKip");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('hasSeenTutorialPengajuanIzin3Jam', true);
        },
        onFinish: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('hasSeenTutorialPengajuanIzin3Jam', true);
          debugPrint("Finish");
        })
      ..show(context: context);
  }

  void _initTarget() {
    targets = [
      // button buat ijin
      TargetFocus(
        identify: "create-key",
        shape: ShapeLightFocus.RRect,
        keyTarget: createKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'Untuk membuat izin 3 jam',
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
      // buat filter
      TargetFocus(
        identify: "filter-key",
        shape: ShapeLightFocus.RRect,
        keyTarget: filterKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'Untuk filter tabel',
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
      //  tabel
      TargetFocus(
        identify: "table-key",
        keyTarget: tableKey,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: 'List Laporan',
                next: 'Finish',
                onNext: () {
                  setState(() async {
                    controller.next();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('hasSeenTutorialPengajuanIzin3Jam', true);
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
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      seeTutorial = await hasSeen();
      debugPrint('ini TUTOR : $seeTutorial');
      if (seeTutorial == false) {
        _showTutorialCoachmark();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: DrawerBuilder(
        userMe: appbarController.fetchUserMe(),
      ),
      body: FutureBuilder(
        future: controller.execute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingFour(
                size: 20,
                color: Colors.amber,
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
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
                  right: 20,
                  left: 20,
                  bottom: 50,
                ),
                children: [
                  const Text(
                    'Izin 3 Jam',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 120),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor: kBlueColor,
                          fixedSize: const Size(147, 23)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) => Dialog(
                                insetPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Form(
                                  key: formkey,
                                  child: Container(
                                    width: 320,
                                    height: 450,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'FORM PEMBUATAN IZIN 3 JAM',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Judul Izin 3 Jam',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 270,
                                            height: 60,
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              controller: judulIzinController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Masukkan judul izin';
                                                }
                                                if (value.length > 30) {
                                                  return 'judul maksimal 30 karakter';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Tanggal Izin',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 270,
                                            height: 60,
                                            child: TextFormField(
                                              controller: tglFormController,
                                              keyboardType: TextInputType.none,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'tanggal harus diisi';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                // hintText: 'tanggal awal',
                                                fillColor: Colors.white24,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 0, 5),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
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
                                                      var hari = DateFormat.d()
                                                          .format(value!);
                                                      var bulan2 =
                                                          DateFormat.M()
                                                              .format(value);
                                                      var tahun = DateFormat.y()
                                                          .format(value);
                                                      tglFormController.text =
                                                          '$hari/$bulan2/$tahun';
                                                      tanggalAPI =
                                                          '$tahun-$bulan2-$hari';
                                                      date = value;
                                                    } catch (e) {
                                                      null;
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Start Durasi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 270,
                                            height: 60,
                                            child: TextFormField(
                                              controller:
                                                  startDurasiIzinController,
                                              keyboardType: TextInputType.none,
                                              inputFormatters: <TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(
                                                    5),
                                              ],
                                              validator: startTimeValidator,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: '00:00',
                                                fillColor: Colors.white24,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 0, 10),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _selectStartTime(context);
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'End Durasi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 270,
                                            height: 60,
                                            child: TextFormField(
                                              controller:
                                                  endDurasiIzinController,
                                              keyboardType: TextInputType.none,
                                              inputFormatters: <TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(
                                                    5),
                                              ],
                                              onTap: () {
                                                setState(() {
                                                  _selectEndTime(context);
                                                });
                                              },
                                              validator: endTimeValidator,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: '00:00',
                                                fillColor: Colors.white24,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 0, 10),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 35,
                                              right: 35,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      fixedSize:
                                                          const Size(84, 29),
                                                      backgroundColor:
                                                          kLightGrayColor,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Batal',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      fixedSize:
                                                          const Size(84, 29),
                                                      backgroundColor:
                                                          kBlueColor,
                                                    ),
                                                    onPressed: () async {
                                                      if (formkey.currentState!
                                                          .validate()) {
                                                        await pengajuanIzin3JamController
                                                            .pengajuan(
                                                          judulIzinController
                                                              .text,
                                                          tanggalAPI,
                                                          startDurasiIzinController
                                                              .text,
                                                          endDurasiIzinController
                                                              .text,
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Save',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      key: createKey,
                      child: const Text(
                        'Buat Izin 3 Jam',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    key: filterKey,
                    children: [
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
                                    (value) async {
                                      try {
                                        startDate = value;
                                        var hari =
                                            DateFormat.d().format(value!);
                                        var bulan =
                                            DateFormat.M().format(value);
                                        var tahun =
                                            DateFormat.y().format(value);
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
                                controller: tglAkhirController,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  ).then(
                                    (value) async {
                                      try {
                                        endData = value;

                                        var hari =
                                            DateFormat.d().format(value!);
                                        var bulan =
                                            DateFormat.M().format(value);

                                        var tahun =
                                            DateFormat.y().format(value);
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
                          Expanded(
                            child: SizedBox(
                              width: 149,
                              child: GetBuilder<Izin3JamListController>(
                                builder: (controller) =>
                                    DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 5),
                                    hintText: 'Status',
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kBlackColor)),
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) async {
                                    // setState(
                                    //   () {
                                    //   },
                                    // );

                                    chosevalue = value.toString();
                                    chosevalue = value!;
                                    controller.filterStatus2.value = chosevalue;
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
                              child: GetBuilder<Izin3JamListController>(
                                builder: (controller) =>
                                    DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 5),
                                    hintText: 'Show',
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kBlackColor)),
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) async {
                                    // setState(
                                    //   () {
                                    //   },
                                    // );
                                    chosevaluedua = value.toString();
                                    chosevaluedua = value!;
                                    pageSize = int.parse(chosevaluedua);
                                    controller.pageSize.value = pageSize;
                                    fetchData();
                                    // controller.dataIzin3Jam.value =
                                    //     await controller.execute(size: int.parse(value!));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => SingleChildScrollView(
                      key: tableKey,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xff12EEB9)),
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
                            'Judul Izin 3 Jam',
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
                            'Durasi Izin',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'Status',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'Actions',
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
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                  ],
                                ),
                              ]
                            : List<DataRow>.generate(
                                controller.dataIzin3Jam.length,
                                (int index) {
                                  int rowIndex =
                                      (controller.pageNum.value - 1) *
                                              controller.pageSize.value +
                                          index +
                                          1;

                                  ListIzin3JamModel data =
                                      controller.dataIzin3Jam[index];
                                  return DataRow(
                                    onLongPress: () async {
                                      await Get.toNamed(Routes.izinDetail3Jam,
                                          arguments: data.id);
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
                                                        Routes
                                                            .editIzinDetail3Jam,
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
                                                                color: Colors
                                                                    .white,
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
                                                                            .circular(8),
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
                                                                        width:
                                                                            34,
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
                                                                          await deletePengajuanIzin3JamController
                                                                              .deletePengajuanIzin3Jam(data.id);
                                                                          await fetchData();

                                                                          // DeleteIzin3JamService().deleteIzin3Jam(
                                                                          //     dataIzin3Jam[
                                                                          //             index]
                                                                          //         [
                                                                          //         'id'],
                                                                          //     context);
                                                                          // Future.delayed(
                                                                          //     const Duration(
                                                                          //         milliseconds:
                                                                          //             300),
                                                                          //     () {
                                                                          // fetchData();
                                                                          // });
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
                                                          color:
                                                              kLightGrayColor,
                                                        ),
                                                        onPressed: () async {
                                                          // Navigate to another page with the id obtained from the API
                                                          await Get.toNamed(
                                                            Routes
                                                                .editIzinDetail3Jam,
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
                                                                child:
                                                                    Container(
                                                                  width: 278,
                                                                  height: 270,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
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
                                                                            top:
                                                                                Radius.circular(8),
                                                                          ),
                                                                          color:
                                                                              Color(0xffFFF068),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      Image
                                                                          .asset(
                                                                        'assets/warning logo.png',
                                                                        width:
                                                                            80,
                                                                        height:
                                                                            80,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            7,
                                                                      ),
                                                                      const Text(
                                                                        'Apakah anda yakin\nmengcancel pengajuan ini?',
                                                                        textAlign:
                                                                            TextAlign.center,
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
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                              ),
                                                                              backgroundColor: const Color(0xff949494),
                                                                              fixedSize: const Size(100, 35.81),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Cancel',
                                                                              style: TextStyle(
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
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                              ),
                                                                              backgroundColor: const Color(0xffFFF068),
                                                                              fixedSize: const Size(100, 35.81),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              await cancelPengajuanIzin3JamController.cancelIzin3Jam(data.id);
                                                                              await fetchData();
                                                                            },
                                                                            child:
                                                                                const Text(
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
                                                        icon: const Icon(Icons
                                                            .arrow_forward),
                                                        onPressed: () async {
                                                          // Navigate to another page with the id obtained from the API
                                                          await Get.toNamed(
                                                            Routes
                                                                .editIzinDetail3Jam,
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
                          onPressed: controller.pageNum.value > 1
                              ? () => onPageChange(controller.pageNum.value - 1)
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
                                '${controller.pageNum.value}',
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
                          onPressed: controller.dataIzin3Jam.length >=
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

class CoachmarkDesc extends StatefulWidget {
  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = "Skip",
    this.next = "Next",
    this.onSkip,
    this.onNext,
  });

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onSkip,
                child: Text(widget.skip),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: widget.onNext,
                child: Text(
                  widget.next,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
