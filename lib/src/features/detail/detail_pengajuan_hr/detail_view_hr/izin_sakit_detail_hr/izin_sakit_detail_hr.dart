import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/src/core/colors/color.dart';
import 'package:project/src/features/appbar/custom_appbar_widget.dart';
import 'package:project/util/navhr.dart';

import '../../../../../core/model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';
import '../../../../../core/model/pengajuan_pembatalan/izin_sakit_model/detail_pengajuan_izin_sakit_model.dart';
import '../../../../pengajuan/edit_pengajuan/edit_pengajuan_izin_sakit/widget/get_attachment_izin_sakit_controller.dart';
import '../../../detail_pengajuan/detail_view/izin_sakit_detail/widget/izin_sakit_download_attachment_modal.dart';
import '../../detail_izin_sakit_hr/widget/detail_izin_sakit_hr_controller.dart';

class DetailIzinSakitViewTabelHR extends StatefulWidget {
  const DetailIzinSakitViewTabelHR({super.key});
  @override
  State<DetailIzinSakitViewTabelHR> createState() =>
      _DetailIzinSakitViewTabelHRState();
}

class _DetailIzinSakitViewTabelHRState
    extends State<DetailIzinSakitViewTabelHR> {
  final args = Get.arguments;

  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  final TextEditingController hariController = TextEditingController();
  final TextEditingController judulSakit = TextEditingController();

  final controller = Get.find<DetailIzinSakitHrController>();
  final izinSakitDownloadAttachmentController =
      Get.find<DownloadIzinSakitController>();
  final izinSakitGetAttachmentController =
      Get.find<GetAttachmentIzinSakitController>();

  final formKey = GlobalKey<FormState>();
  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round();
    return durasi;
  }

  FilePickerResult? result;
  bool isLoading = false;
  List<File>? files;
  int maxFiles = 5;
  int maxFileSize = 10485760;
  String? errorMessage;

  Map<String, dynamic> dataIzinSakit = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  late Future<DetailPengajuanIzinSakitModel> _fetchDataIzinSakit;
  late List<AttachmentIzinSakitModel> resultAttachment;

  Future getAttachment(int id) async {
    resultAttachment = await izinSakitGetAttachmentController.attach(args);
  }

  Future<Map<String, dynamic>> getData() async {
    final value1 = await _fetchDataIzinSakit;
    final value2 = await getAttachment(args);
    return {
      'value1': value1,
      'value2': value2,
    };
  }

  Future downAttach(int idFile, String fileName, context) async {
    await izinSakitDownloadAttachmentController.IzinSakitDownload(
        idFile, fileName, context);
  }

  @override
  void initState() {
    super.initState();
    _fetchDataIzinSakit = controller.execute(args);
    getAttachment(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error Fetching data');
          } else {
            final hasil = snapshot.data!;
            DetailPengajuanIzinSakitModel? data = hasil['value1'];
            judulSakit.text = data!.judul;
            hariController.text = data.jumlahHari.toString();

            final dynamic inputDateAwalString = data.tanggalAwal.toString();
            final inputDateAwalFormat = DateFormat('yyyy-MM-dd');
            final outputDateAwalFormat = DateFormat('d/M/y');
            final inputDateAwal =
                inputDateAwalFormat.parse(inputDateAwalString);
            final outputDateAwalString =
                outputDateAwalFormat.format(inputDateAwal);
            tglAwalformController.text = outputDateAwalString;

            final dynamic inputDateAkhirString = data.tanggalAkhir.toString();
            final inputDateAkhirFormat = DateFormat('yyyy-MM-dd');
            final outputDateAkhirFormat = DateFormat('d/M/y');
            final inputDateAkhir =
                inputDateAkhirFormat.parse(inputDateAkhirString);
            final outputDateAkhirString =
                outputDateAkhirFormat.format(inputDateAkhir);
            tglAkhirformController.text = outputDateAkhirString;
            //Attachment
            final filesData = resultAttachment.map((data2) {
              return {
                'id': data2.id,
                'path': data2.namaAttachment,
              };
            }).toList();
            combinedList = [
              ...filesData,
              ...?files?.map((file) => {'path': file.path}),
            ];
            return Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: 50,
                ),
                children: [
                  const Text(
                    'HR Detail Izin Sakit',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Judul Izin Sakit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kBlackColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 270,
                    height: 35,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: judulSakit,
                      decoration: InputDecoration(
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
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 55,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Text(
                                    'Tanggal Awal',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        SizedBox(
                          width: 120,
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 55,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Text(
                                    'Tanggal Akhir',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
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
                  const SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Row(
                      children: [
                        SizedBox(
                          width: 138,
                          height: 35,
                          child: TextFormField(
                            controller: tglAwalformController,
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                              // hintText: 'tanggal awal',
                              fillColor: Colors.white24,
                              filled: true,
                              // contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(
                          width: 44,
                        ),
                        SizedBox(
                          width: 138,
                          height: 35,
                          child: TextFormField(
                            controller: tglAkhirformController,
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                              // hintText: 'tanggal awal',
                              fillColor: Colors.white24,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('File Lampiran Opsional'),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: combinedList
                                    .asMap()
                                    .map(
                                      (index, file) => MapEntry(
                                        index,
                                        Container(
                                          // padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    '${index + 1}. ${file['path'].split('/').last}'),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  if (!Platform.isAndroid) {
                                                    return;
                                                  }

                                                  var status = await Permission
                                                      .storage
                                                      .request();

                                                  if (status
                                                      .isPermanentlyDenied) {
                                                    var newStatus =
                                                        await Permission
                                                            .manageExternalStorage
                                                            .request();
                                                    if (!newStatus
                                                        .isRestricted) {
                                                      status = newStatus;
                                                    }
                                                  }

                                                  if (status.isGranted) {
                                                    if (context.mounted) {
                                                      downAttach(
                                                        file['id'],
                                                        file['path'],
                                                        context,
                                                      );
                                                    }
                                                  }

                                                  if (status
                                                      .isPermanentlyDenied) {
                                                    if (context.mounted) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Container(
                                                                width: 278,
                                                                height: 270,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                        .white),
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
                                                                        color:
                                                                            kRedColor,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    const Icon(
                                                                      Icons
                                                                          .warning_amber,
                                                                      color:
                                                                          kRedColor,
                                                                      size: 80,
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    const Text(
                                                                      'Tidak mendapatkan akses\nuntuk menulis file',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            kBlackColor,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          24,
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
                                                                            kRedColor,
                                                                        fixedSize: const Size(
                                                                            120,
                                                                            45),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        openAppSettings();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Buka Setting',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              kWhiteColor,
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
                                                icon:
                                                    const Icon(Icons.download),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: kLightOrangeColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.status,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: kNormalOrangeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Obx(
                    () =>
                        izinSakitDownloadAttachmentController.downloading.value
                            ? LinearProgressIndicator(
                                value: izinSakitDownloadAttachmentController
                                        .progress.value /
                                    100)
                            : const SizedBox(
                                height: 10,
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
