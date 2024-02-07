import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/pengajuan/izin_sakit/widgets/izin_sakit_list_controller.dart';
import 'package:project/src/features/pengajuan/izin_sakit/widgets/pengajuan_filter_widget.dart';
import 'package:project/util/navkaryawan.dart';

import '../../../../util/drawerBuilder.dart';
import '../../../core/colors/color.dart';
import '../../../core/model/pengajuan_pembatalan/izin_sakit_model/izin_sakit_model.dart';
import '../../appbar/appbar_controller.dart';
import '../../appbar/custom_appbar_widget.dart';
import '../../detail/detail_pengajuan/detail_izin_sakit/widget/cancel_izin_sakit_controller.dart';
import '../../detail/detail_pengajuan/detail_izin_sakit/widget/delete_izin_sakit_controller.dart';
import 'widgets/pengajuan_header_widget.dart';

String judulIzinSakit = '';
String tanggalAwalizin = '';
String tanggalAkhirizin = '';
String jumlahhariizin = '';

class PengajuanIzinSakitPage extends GetView<IzinSakitListController> {
  final TextEditingController tglAwalController =
      TextEditingController(text: tglAwalFilter);
  final TextEditingController tglAkhirController =
      TextEditingController(text: tglAkhirFilter);
  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  final TextEditingController hariController = TextEditingController();

  final appbarController = Get.find<AppBarController>();
  final deleteIzinSakitPengajuanController =
      Get.find<DeleteIzinSakitController>();
  final cancelIzinSakitPengajuancontroller =
      Get.find<CancelIzinSakitController>();

  final TextEditingController judulSakit = TextEditingController();
  final formkey = GlobalKey<FormState>();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIa = '';
  String tanggalAPIb = '';

  PengajuanIzinSakitPage({super.key});
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

  // List<dynamic> izinSakitList = [];

  Future<void> fetchData() async {
    controller.execute(
      page: page,
      filterStatus: chosevalue,
      size: pageSize,
      tanggalAwal: tgllAwal,
      tanggalAkhir: tgllAkhir,
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
            PengajuanHeaderWidget(),
            20.height,
            PengajuanFilterWidget(),
            20.height,
            Obx(
              () => controller.isFetchData.value
                  ? const SpinKitDualRing(
                      color: kBlueColor,
                      size: 20,
                    ).center()
                  : controller.izinSakitList.value.isEmpty
                      ? const Text('Kosong..')
                      : SingleChildScrollView(
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
                              controller.izinSakitList.value.length,
                              (int index) {
                                int rowIndex =
                                    (page - 1) * pageSize + index + 1;

                                IzinSakitModel data =
                                    controller.izinSakitList.value[index];

                                return DataRow(
                                  onLongPress: () async {
                                    await Get.toNamed(Routes.izinSakitDetail,
                                        arguments: data.id);
                                  },
                                  cells: [
                                    DataCell(Text(rowIndex.toString())),
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
                                                      Routes.editIzinSakitt,
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
                                                                        await deleteIzinSakitPengajuanController
                                                                            .deleteIzinSakitPengajuan(data.id);
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
                                                          Routes.editIzinSakitt,
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
                                                                            await cancelIzinSakitPengajuancontroller.cancelledIzinSakit(data.id);
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
                                                          Routes.editIzinSakitt,
                                                          arguments: data.id,
                                                        );
                                                        // Navigate to another page with the id obtained from the API
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
                    ),
                  ),
                  //jika user sudah menekan dropdown,
                  // jika panjang list itu kurang dari nilai yang ditekan di dalam dropdown
                  // controller.izinSakitList.length <= 20
                  //     ? const SizedBox() :
                  IconButton(
                    onPressed: controller.izinSakitList.length >= pageSize
                        ? () => onPageChange(page + 1)
                        : null,
                    icon: const Icon(Icons.keyboard_arrow_right),
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
