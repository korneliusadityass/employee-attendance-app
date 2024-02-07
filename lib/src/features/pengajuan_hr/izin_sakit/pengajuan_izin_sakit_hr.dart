import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/features/pengajuan_hr/izin_sakit/widget/hr_izin_sakit_list_controller.dart';
import 'package:project/src/features/pengajuan_hr/izin_sakit/widget/hr_pengajuan_filter_widget.dart';
import 'package:project/src/features/pengajuan_hr/izin_sakit/widget/hr_pengajuan_header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../util/navhr.dart';
import '../../../core/colors/color.dart';
import '../../../core/model/hr_pengajuan_pembatalan/izin_sakit/list_izin_sakit_hr_model.dart';
import '../../../core/routes/routes.dart';
import '../../appbar/custom_appbar_widget.dart';
import '../../detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/cancel_izin_sakit_hr_controller.dart';
import '../../detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/delete_izin_sakit_hr_controller.dart';
// import '../services/izin_sakit_services/izin_sakit_input_services.dart';

String judulIzinSakitHR = '';
String tanggalAwalizinHR = '';
String tanggalAkhirizinHR = '';
String jumlahhariizinHR = '';
String namaKaryawanHR = '';

class PengajuanIzinSakitHR extends StatefulWidget {
  const PengajuanIzinSakitHR({super.key});

  @override
  State<PengajuanIzinSakitHR> createState() => _PengajuanIzinSakitHRState();
}

class _PengajuanIzinSakitHRState extends State<PengajuanIzinSakitHR> {
  final controller = Get.find<HrIzinSakitListController>();

  final TextEditingController tglAwalController = TextEditingController();

  final TextEditingController tglAkhirController = TextEditingController();

  final TextEditingController tglAwalformController = TextEditingController();

  final TextEditingController tglAkhirformController = TextEditingController();

  final TextEditingController hariController = TextEditingController();

  final TextEditingController judulSakit = TextEditingController();

  final formkey = GlobalKey<FormState>();

  final TextEditingController namaKaryawan = TextEditingController();

  final deleteIzinSakitHrController = Get.find<DeleteIzinSakitHrController>();

  final cancelIzinSakitHrController = Get.find<CancelIzinSakitHrController>();

  // String? namaKaryawan;
  int? idKaryawan;

  // TutorialCoachMark? tutorialCoachMark;

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

    return null;
  }

  var durasi = 0;

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round();
    return durasi;
  }

  var selectedItem = '';

  String chosevalue = 'All';

  String chosevaluedua = '10';

  String? tgllAwal;

  String? tgllAkhir;

  int pageSize = 10;

  int page = 1;

  bool isFetchingData = true;

  int currentYear = 0;

  // List<dynamic> izinSakitList = [];
  Future<void> fetchData() async {
    controller.execute(
      page: page,
      tanggalAwal: tgllAwal,
      tanggalAkhir: tgllAkhir,
      filterStatus: chosevalue,
      size: controller.pageSize.value,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  late TutorialCoachMark tutorialCoachMark;
  bool seeTutorial = false;
  GlobalKey keybutton = GlobalKey();
  GlobalKey filterkey = GlobalKey();
  GlobalKey tableKey = GlobalKey();

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
        identify: "key-button",
        keyTarget: keybutton,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachMarkDesc(
                text: "Ini button create izin",
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
        identify: "filter-key",
        keyTarget: filterkey,
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
        identify: "table-key",
        keyTarget: tableKey,
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
            PengajuanHeaderWidgetHR(key: keybutton),
            10.height,
            HrPengajuanFilter(
              key: filterkey,
            ),
            20.height,
            Obx(
              () => controller.isFetchData.value
                  ? const SpinKitDualRing(
                      color: kBlueColor,
                      size: 20,
                    ).center()
                  : controller.hrIzinSakitList.isEmpty
                      ? const Text('Kosong..')
                      : SingleChildScrollView(
                          key: tableKey,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
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
                              DataColumn(
                                label: Text(
                                  'Actions',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              controller.hrIzinSakitList.length,
                              (int index) {
                                // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                                int rowIndex =
                                    (page - 1) * controller.pageSize.value +
                                        index +
                                        1;
                                HrListIzinSakitModel data =
                                    controller.hrIzinSakitList[index];
                                return DataRow(
                                  onLongPress: () async {
                                    // Navigate to another page with the id obtained from the API
                                    await Get.toNamed(Routes.izinSakitHrDetail,
                                        arguments: data.id);
                                  },
                                  cells: [
                                    DataCell(Text(rowIndex.toString())),
                                    DataCell(Text(data.namaKaryawan)),
                                    DataCell(Text(data.judul)),
                                    DataCell(Text(
                                        '${data.tanggalAwal.toString().substring(0, 10)} - ${data.tanggalAkhir.toString().substring(0, 10)}')),
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
                                                        Routes.editIzinSakittHr,
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
                                                                        await deleteIzinSakitHrController
                                                                            .deleteIzinSakitPengajuanHr(data.id);
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
                                                                .editIzinSakittHr,
                                                            arguments: data.id);
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.cancel_outlined,
                                                        color: kRedColor,
                                                      ),
                                                      onPressed: () async {
                                                        await cancelIzinSakitHrController
                                                            .cancelledIzinSakitHr(
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
                                                        await Get.toNamed(
                                                            Routes
                                                                .editIzinSakittHr,
                                                            arguments: data.id);
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
                    // onPressed: page > 1 ? () => onPageChange(page - 1) : null,
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
                              color: kWhiteColor, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right),
                    onPressed: controller.hrIzinSakitList.length >=
                            controller.pageSize.value
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
