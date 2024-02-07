import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/core/model/cuti_tahunan-model/cuti_tahunan_model.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/cuti_tahunan_filter_widget.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/widgets/cuti_tahunan_header_widget.dart';

import '../../../../util/drawerBuilder.dart';
import '../../../core/colors/color.dart';
import '../../../core/routes/routes.dart';
import '../../appbar/appbar_controller.dart';
import '../../appbar/custom_appbar_widget.dart';
import '../../detail/detail_pengajuan/detail_cuti_tahunan/widget/cancel_cuti_tahunan_controller.dart';
import '../../detail/detail_pengajuan/detail_cuti_tahunan/widget/delete_cuti_tahunan_controller.dart';

// String judulCutiTahunan = '';
// String tanggalAwalCutiTahunan = '';
// String tanggalAkhirCutiTahunan = '';
// String jumlahhariCutiTahunan = '';

class PengajuanCutiTahunan extends GetView<CutiTahunanListController> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController tglAwalController =
      TextEditingController(text: tglAwalFilterCuti);
  final TextEditingController tglAkhirController =
      TextEditingController(text: tglAkhirFilterCuti);
  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  // final TextEditingController hariController = TextEditingController();
  final TextEditingController sisaCutiController = TextEditingController();
  final TextEditingController judulCutiTahunanController =
      TextEditingController();

  final appbarController = Get.find<AppBarController>();
  final deleteCutiTahunanPengajuanController =
      Get.find<DeleteCutiTahunanController>();
  final cancelCutiTahunanPengajuanController =
      Get.find<CancelledCutiTahunanController>();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIa = '';
  String tanggalAPIb = '';

  PengajuanCutiTahunan({super.key});
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
    fetchData();
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
            PengajuanCutiTahunanHeaderWidget(),
            10.height,
            PengajuanFilterWidgetCutiTahunan(),
            20.height,
            Obx(
              () => controller.isFetchData.value
                  ? const SpinKitDualRing(
                      color: kBlueColor,
                      size: 20,
                    ).center()
                  : controller.cutiTahunanList.value.isEmpty
                      ? const Text('Kosong...')
                      : SingleChildScrollView(
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
                              controller.cutiTahunanList.value.length,
                              (int index) {
                                int rowIndex =
                                    (page - 1) * pageSize + index + 1;

                                CutitahunanModel data =
                                    controller.cutiTahunanList.value[index];
                                return DataRow(
                                  onLongPress: () async {
                                    await Get.toNamed(Routes.cutiTahunanDetail,
                                        arguments: data.id);
                                  },
                                  cells: [
                                    DataCell(Text(rowIndex.toString())),
                                    DataCell(Text(data.judulCutiTahunan)),
                                    DataCell(Text(
                                        '${data.tanggalAwal.toString().substring(0, 10)} - ${data.tanggalAkhir.toString().substring(0, 10)}')),
                                    DataCell(Text(
                                        data.jumlahhariCutiTahunan.toString())),
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
                                                        Routes.editCutiTahunan,
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
                                                                12.height,
                                                                Image.asset(
                                                                  'assets/warning logo.png',
                                                                  width: 80,
                                                                  height: 80,
                                                                ),
                                                                7.height,
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
                                                                24.height,
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
                                                                    34.width,
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
                                                                        await deleteCutiTahunanPengajuanController
                                                                            .deleteCutiTahunanPengajuan(data.id);
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
                                                              .editCutiTahunan,
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
                                                                    12.height,
                                                                    Image.asset(
                                                                      'assets/warning logo.png',
                                                                      width: 80,
                                                                      height:
                                                                          80,
                                                                    ),
                                                                    7.height,
                                                                    const Text(
                                                                      'Apakah anda yakin\nmengcancel pengajuan ini?',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    24.height,
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
                                                                              fontSize: 18,
                                                                              color: kWhiteColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        34.width,
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
                                                                            await cancelCutiTahunanPengajuanController.cancelledCutiTahunan(data.id);
                                                                            await fetchData();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Ya',
                                                                            style:
                                                                                TextStyle(
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
                                                        await Get.toNamed(
                                                          Routes
                                                              .editCutiTahunan,
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
            15.height,
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
                    onPressed: controller.cutiTahunanList.length >= pageSize
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
