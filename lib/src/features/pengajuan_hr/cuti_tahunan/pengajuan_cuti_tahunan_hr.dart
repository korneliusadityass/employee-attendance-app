import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/cuti_tahunan/cuti_tahunan_model_hr.dart';
import 'package:project/src/features/pengajuan_hr/cuti_tahunan/widget/hr_cuti_tahunan_list_controller.dart';
import 'package:project/src/features/pengajuan_hr/cuti_tahunan/widget/hr_pengajuan_filter.dart';
import 'package:project/src/features/pengajuan_hr/cuti_tahunan/widget/hr_pengajuan_header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../util/navhr.dart';
import '../../../core/colors/color.dart';
import '../../../core/routes/routes.dart';
import '../../appbar/custom_appbar_widget.dart';
import '../../detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/cancel_cuti_tahunan_hr_controller.dart';
import '../../detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/delete_cuti_tahunan_hr_controller.dart';

// String judulCutiTahunan = '';
// String tanggalAwalCutiTahunan = '';
// String tanggalAkhirCutiTahunan = '';
// String jumlahhariCutiTahunan = '';

class PengajuanCutiTahunanHR extends StatefulWidget {
  const PengajuanCutiTahunanHR({super.key});

  @override
  State<PengajuanCutiTahunanHR> createState() => _PengajuanCutiTahunanHRState();
}

class _PengajuanCutiTahunanHRState extends State<PengajuanCutiTahunanHR> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController tglAwalController = TextEditingController();

  final TextEditingController tglAkhirController = TextEditingController();

  final TextEditingController tglAwalformController = TextEditingController();

  final TextEditingController tglAkhirformController = TextEditingController();

  final TextEditingController namaKaryawan = TextEditingController();

  final TextEditingController sisaCutiController = TextEditingController();

  final TextEditingController judulCutiTahunanController =
      TextEditingController();

  final deleteCutiTahunanController = Get.find<DeleteCutiTahunanHrController>();

  final cancelledCutiTahunanController =
      Get.find<CancelCutiTahunanHrController>();

  final controller = Get.find<CutiTahunanHrListController>();

  int? idKaryawan;

  DateTime? endData;

  DateTime? startDate;

  String tanggalAPIa = '';

  String tanggalAPIb = '';

  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal!";
    }
    if (endData == null) return "pilih tanggal";
    if (endData!.isBefore(startDate!)) {
      return "tanggal akhir setelah tanggal awal";
    }

    return null; // optional while already return type is null
  }

  var durasi = 0;

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round() + 1;

    return durasi;
  }

  String chosevalue = 'All';

  String chosevaluedua = '10';

  String? tglAwal;

  String? tglAkhir;

  int pageSize = 10;

  int page = 1;

  bool isFetchingData = true;

  int currentYear = 0;

  // List<dynamic> cutiTahunanList = [];
  Future<void> fetchData() async {
    controller.execute(
      page: page,
      size: pageSize,
      filterStatus: chosevalue,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    // setState(() {
    // });
    fetchData();
  }

  late TutorialCoachMark tutorialCoachMark;

  bool seeTutorial = false;

  GlobalKey keybuttoncuti = GlobalKey();
  // GlobalKey keykuota = GlobalKey();

  GlobalKey filterkeycuti = GlobalKey();

  GlobalKey tableKeycuti = GlobalKey();

  Future hasSeen() async {
    SharedPreferences prefss = await SharedPreferences.getInstance();
    final result = prefss.getBool('Tutorial izin sakit by HR ') ?? false;
    return result;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      seeTutorial = await hasSeen();
      debugPrint('ini Tutor: $seeTutorial');
      if (seeTutorial == false) {
        _showTutorialCoachMark();
      }
    });
  }

  void _showTutorialCoachMark() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _initTarget(),
      pulseEnable: false,
      onClickTarget: (targets) {
        print("${targets.identify}");
      },
      // hideSkip: true,
      alignSkip: Alignment.topRight,
      onSkip: () async {
        // print("skipp");
        SharedPreferences prefss = await SharedPreferences.getInstance();
        prefss.setBool("hasSeenTutorialIzinSakitHr", true);
      },
      onFinish: () {
        debugPrint("Finish");
      },
    )..show(context: context);
  }

  List<TargetFocus> _initTarget() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "key-button-cuti",
        keyTarget: keybuttoncuti,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachMarkDesc(
                text: "Ini button create cuti",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "filter-key-cuti",
        keyTarget: filterkeycuti,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachMarkDesc(
                text: "ini filter untuk table",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "table-key-cuti",
        keyTarget: tableKeycuti,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return CoachMarkDesc(
                text: "Ini table list pengajuan",
                next: 'finis',
                onNext: () {
                  setState(() async {
                    controller.next();
                    SharedPreferences prefss =
                        await SharedPreferences.getInstance();
                    prefss.setBool('hasSeenTutorianIzinSakit', true);
                  });
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
    );

    return targets;
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
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: 50,
          ),
          children: [
            PengajuanCutiHrWidgetHeader(
              key: keybuttoncuti,
            ),
            10.height,
            PengajuanCutiHrWidgetFilter(
              key: filterkeycuti,
            ),
            20.height,
            Obx(
              () => controller.isFetchData.value
                  ? const SpinKitDualRing(
                      color: kBlueColor,
                      size: 20,
                    ).center()
                  : controller.cutiTahunanHrList.isEmpty
                      ? const Text('Kosong...')
                      : SingleChildScrollView(
                          key: tableKeycuti,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
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
                                  'Judul Cuti Tahunan',
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
                                label: Padding(
                                  padding: EdgeInsets.only(
                                    left: 50,
                                  ),
                                  child: Text(
                                    'Action',
                                    style: TextStyle(
                                      color: kWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              controller.cutiTahunanHrList.length,
                              (int index) {
                                int rowIndex =
                                    (page - 1) * pageSize + index + 1;
                                CutiTahunanHrModel data =
                                    controller.cutiTahunanHrList[index];
                                return DataRow(
                                  onLongPress: () async {
                                    await Get.toNamed(
                                        Routes.cutiTahunanHrDetail,
                                        arguments: data.id);
                                  },
                                  cells: [
                                    DataCell(Text(rowIndex.toString())),
                                    DataCell(Text(data.namaKaryawan)),
                                    DataCell(Text(data.judul)),
                                    DataCell(Text(
                                        '${data.tanggalAwal.toString().substring(0, 10)} - ${data.tanggalAkhir.toString().substring(0, 10)}')),
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
                                                    await Get.toNamed(
                                                        Routes
                                                            .editCutiTahunanHr,
                                                        arguments: data.id);
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
                                                                        await deleteCutiTahunanController
                                                                            .deleteCutiTahunanPengajuanHr(data.id);
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
                                                        await Get.toNamed(
                                                            Routes
                                                                .editCutiTahunanHr,
                                                            arguments: data.id);
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.cancel_outlined,
                                                        color: kRedColor,
                                                      ),
                                                      onPressed: () async {
                                                        // Change the status of the data to 'Cancelled'
                                                        await cancelledCutiTahunanController
                                                            .cancelledCutiTahunanHr(
                                                                data.id);
                                                        await fetchData();
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
                                                        // await Get.toNamed(Routes.editCutiTahunanHr);
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
                              color: kWhiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )),
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right),
                    onPressed: controller.cutiTahunanHrList.length >= pageSize
                        ? () => onPageChange(page + 1)
                        : null,
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

class CoachMarkDesc extends StatefulWidget {
  const CoachMarkDesc({
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
  State<CoachMarkDesc> createState() => _CoachMarkDescState();
}

class _CoachMarkDescState extends State<CoachMarkDesc>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 20,
      duration: const Duration(milliseconds: 800),
    )..repeat(min: 0, max: 20, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            animationController.value,
          ),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(widget.skip),
                ),
                16.height,
                ElevatedButton(
                  onPressed: widget.onNext,
                  child: Text(widget.next),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
