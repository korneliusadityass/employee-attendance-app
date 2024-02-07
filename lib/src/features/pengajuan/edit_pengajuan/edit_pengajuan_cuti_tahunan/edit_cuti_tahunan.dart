// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/pengajuan_cuti_tahunan.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/delete_attachment_edit_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/edit_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/get_attachment_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_cuti_tahunan/widget/input_attachment_cuti_tahunan_confirm_approve_controller.dart';

import '../../../../../util/drawerBuilder.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/cuti_tahunan-model/detail_pengajuan_cuti_tahunan_model.dart';
import '../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/attachment_cuti_tahunan_hr_model.dart';
import '../../../appbar/appbar_controller.dart';
import '../../../appbar/custom_appbar_widget.dart';
import '../../../detail/detail_pengajuan/detail_cuti_tahunan/widget/confirm_cuti_tahunan_controler.dart';
import '../../../detail/detail_pengajuan/detail_cuti_tahunan/widget/input_attachment_cuti_tahunan_controller.dart';
import '../../../detail/detail_pengajuan/detail_view/cuti_tahunan_detail/widget/cuti_tahunan_detail_controller.dart';

class EditCutiTahunan extends StatefulWidget {
  // final int id;
  const EditCutiTahunan({super.key});

  @override
  State<EditCutiTahunan> createState() => _EditCutiTahunanState();
}

class _EditCutiTahunanState extends State<EditCutiTahunan> {
  final TextEditingController judulCuti = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final DateFormat formatter = DateFormat("dd/MM/YYYY");
  final formKey = GlobalKey<FormState>();

  final args = Get.arguments;
  final deleteAttachmentController =
      Get.find<DeleteAttachmentCutiTahunanController>();
  final editPengajuanCutiTahunanController =
      Get.find<EditCutiTahunanController>();
  final inputAttachmentConfirmApproveController =
      Get.find<InputAttachmentConfirmApproveEditCutiTahunanController>();
  final getAttachmentController =
      Get.find<GetAttachmentCutiTahunanController>();
  final inputAttachmentController =
      Get.find<InputAttachmentCutiTahunanController>();
  final confirmCutitahunanController = Get.find<ConfirmCutiTahunanController>();
  final controller = Get.find<DetailCutiTahunanController>();
  final appbarController = Get.find<AppBarController>();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIa = '';
  String tanggalAPIb = '';
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
    durasi = (to.difference(from).inHours / 24).round();
    return durasi;
  }

  FilePickerResult? result;
  bool isLoading = false;
  List<File>? files;
  int maxFiles = 5;
  int maxFileSize = 10485760;
  String? errorMessage;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'pdf', 'jpg'],
        allowMultiple: true,
      );
      if (result != null) {
        List<PlatformFile>? platformFiles = result!.files;
        List<File> newFiles = [];
        bool hasInvalidFile = false;
        for (PlatformFile platformFile in platformFiles) {
          if (platformFile.size <= maxFileSize) {
            File newFile = File(platformFile.path!);
            newFiles.add(newFile);
          } else {
            debugPrint('File yang diperbolehkan hanya 10mb');
            hasInvalidFile = true;
          }
        }
        if (hasInvalidFile) {
          setState(() {
            errorMessage = 'File yang diperbolehkan hanya 10mb';
          });
        } else if ((files?.length ?? 0) + newFiles.length <= maxFiles) {
          files ??= [];
          files!.addAll(newFiles);
          debugPrint('Selected files: $files');
          setState(() {
            errorMessage = null;
          });
        } else {
          debugPrint('File telah mencapai batas');
          setState(() {
            errorMessage = 'File telah mencapai batas';
          });
          // Add only the first 5 files if more than 5 files are selected
          int maxNewFiles = maxFiles - (files?.length ?? 0);
          if (maxNewFiles > 0) {
            files ??= [];
            files!.addAll(newFiles.take(maxNewFiles));
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, dynamic> cutiTahunanList = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> fileData = [];
  List<Map<String, dynamic>> combineList = [];

  late Future<DetailPengajuanCutiTahunanModel> _fetchDataCutiTahunan;
  late List<AttachmentCutiTahunanModelHr> resultAttachment;
  Future getAttachment(int id) async {
    resultAttachment = await getAttachmentController.attach(args);
  }

  late Future<Map<String, dynamic>> _getData;

  Future<Map<String, dynamic>> getData() async {
    final value1 = await _fetchDataCutiTahunan;
    final value2 = await getAttachment(args);
    return {
      'value1': value1,
      'value2': value2,
    };
  }

  @override
  void initState() {
    super.initState();
    _fetchDataCutiTahunan = controller.execute(args);
    _getData = getData();
    getAttachment(args);
  }

  @override
  Widget build(BuildContext context) {
    // print(cutiTahunanList);
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: DrawerBuilder(
        userMe: appbarController.fetchUserMe(),
      ),
      body: FutureBuilder(
        future: _getData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            final hasil = snapshot.data!;
            DetailPengajuanCutiTahunanModel? data = hasil['value1'];
            AttachmentCutiTahunanModelHr? data2 = hasil['value2'];
            judulCuti.text = data!.judul;
            tglAwalController.text =
                data.tanggalAwal.toString().substring(0, 10);
            tglAkhirController.text =
                data.tanggalAkhir.toString().substring(0, 10);

            final dynamic inputDateString = data.tanggalAwal.toString();
            final inputDateFormat = DateFormat('yyyy-MM-dd');
            final outputDateFormat = DateFormat('d/M/y');
            final inputDate = inputDateFormat.parse(inputDateString);
            final outputDateString = outputDateFormat.format(inputDate);
            tglAwalController.text = outputDateString;
            tanggalAPIa = data.tanggalAwal.toString().substring(0, 10);

            final dynamic inputDateString2 = data.tanggalAkhir.toString();
            final inputDateFormat2 = DateFormat('yyyy-MM-dd');
            final outputDateFormat2 = DateFormat('d/M/y');
            final inputDate2 = inputDateFormat.parse(inputDateString2);
            final outputDateString2 = outputDateFormat.format(inputDate2);
            tglAkhirController.text = outputDateString2;
            tanggalAPIb = data.tanggalAkhir.toString().substring(0, 10);

            final filesData = resultAttachment.map((data2) {
              return {
                'id': data2.id,
                'path': data2.namaAttachment,
              };
            }).toList();
            combineList = [
              ...fileData,
              ...?files?.map((file) => {'path': file.path}),
            ];
            return Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                children: [
                  const Text(
                    'Edit Detail Cuti Tahunan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  15.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Judul Cuti Tahunan',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: kBlackColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 270,
                        height: 35,
                        child: TextFormField(
                          enabled: data.status == 'Draft',
                          keyboardType: TextInputType.none,
                          controller: judulCuti,
                          decoration: InputDecoration(
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                              color: kBlackColor,
                              width: 1,
                            )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
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
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal Awal',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            1.height,
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                enabled: data.status == 'Draft',
                                controller: tglAwalController,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kBlackColor,
                                      width: 1,
                                    ),
                                  ),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
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
                                        startDate = value;
                                        var hari =
                                            DateFormat.d().format(value!);
                                        var bulan =
                                            DateFormat.M().format(value);
                                        var bulan2 =
                                            DateFormat.M().format(value);
                                        var tahun =
                                            DateFormat.y().format(value);
                                        tglAwalController.text =
                                            '$hari/$bulan/$tahun';
                                        tanggalAPIa = '$tahun-$bulan2-$hari';
                                      } catch (e) {
                                        null;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      19.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal Akhir',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            1.height,
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                enabled: data.status == 'Draft',
                                controller: tglAkhirController,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                validator: endDateValidator,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kBlackColor,
                                      width: 1,
                                    ),
                                  ),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
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
                                        endData = value;

                                        var hari =
                                            DateFormat.d().format(value!);
                                        var bulan =
                                            DateFormat.M().format(value);
                                        var bulan2 =
                                            DateFormat.M().format(value);
                                        var tahun =
                                            DateFormat.y().format(value);
                                        tglAkhirController.text =
                                            '$hari/$bulan/$tahun';
                                        tanggalAPIb = '$tahun-$bulan2-$hari';
                                        final difference =
                                            daysBetween(startDate!, endData!);
                                        setState(() {});
                                      } catch (e) {
                                        null;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  15.height,
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
                            : TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: kBlueColor,
                                ),
                                onPressed: () {
                                  pickFile();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cloud_upload_rounded,
                                      color: kWhiteColor,
                                    ),
                                    10.width,
                                    const Text(
                                      'Pilih File',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      12.height,
                      ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: combineList
                            .asMap()
                            .map((index, file) => MapEntry(
                                index,
                                Container(
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
                                              '${index + 1}. ${file['path'].split('/').last}')),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.download),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Container(
                                                  width: 278,
                                                  height: 270,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: 31,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    6),
                                                          ),
                                                          color: kRedColor,
                                                        ),
                                                      ),
                                                      12.height,
                                                      const Icon(
                                                        Icons.warning,
                                                        color: kRedColor,
                                                        size: 80,
                                                      ),
                                                      7.height,
                                                      const Text(
                                                        'apa anda yakin\nmenghapus file ini?\nFile akan hilang',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 16,
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
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              backgroundColor:
                                                                  kGreyColor,
                                                              fixedSize:
                                                                  const Size(
                                                                      100,
                                                                      35.81),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    kWhiteColor,
                                                              ),
                                                            ),
                                                          ),
                                                          34.width,
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              backgroundColor:
                                                                  kRedColor,
                                                              fixedSize:
                                                                  const Size(
                                                                      100,
                                                                      35.81),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await deleteAttachmentController
                                                                  .deleteAttachmentCutiTahunannn(
                                                                      args,
                                                                      file[
                                                                          'id']);
                                                            },
                                                            child: const Text(
                                                              'Ya',
                                                              style: TextStyle(
                                                                fontSize: 20,
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
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                )))
                            .values
                            .toList(),
                      ),
                      5.height,
                      if (errorMessage != null) // tambahkan blok ini
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  15.height,
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
                            fontWeight: FontWeight.w900,
                            color: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  15.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRedColor,
                          fixedSize: const Size(
                            90,
                            29,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 278,
                                  height: 270,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 31,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(8),
                                          ),
                                          color: Color(0xffFFF068),
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
                                        'Apakah yakin ingin kembali\nhal yang anda edit tidak akan tersimpan ?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      24.height,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  const Color(0xff949494),
                                              fixedSize: const Size(100, 35.81),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          ),
                                          34.width,
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  const Color(0xffFFF068),
                                              fixedSize: const Size(100, 35.81),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PengajuanCutiTahunan(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Ya',
                                              style: TextStyle(
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
                        child: const Icon(Icons.cancel_outlined),
                      ),
                      24.width,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreenColor,
                          fixedSize: const Size(
                            90,
                            29,
                          ),
                        ),
                        onPressed: () async {
                          if (files == null) {
                            if (data.status == 'Draft') {
                              await editPengajuanCutiTahunanController
                                  .editCutiTahunan(
                                args,
                                judulCuti.text,
                                tanggalAPIa,
                                tanggalAPIb,
                              );

                              await confirmCutitahunanController
                                  .confirmCutiTahunann(args);
                            } else if (data.status == 'Approved' ||
                                data.status == 'Confirmed') {
                              debugPrint('call');
                              Get.back();
                            }
                          } else {
                            if (data.status == 'Draft') {
                              await editPengajuanCutiTahunanController
                                  .editCutiTahunan(
                                args,
                                judulCuti.text,
                                tanggalAPIa,
                                tanggalAPIb,
                              );

                              await confirmCutitahunanController
                                  .confirmCutiTahunann(args);
                              await inputAttachmentController
                                  .inputAttachmentCutiTahunann(args, files!);
                            }
                            if (data.status == 'Approved' ||
                                data.status == 'Confirmed') {
                              await inputAttachmentConfirmApproveController
                                  .inputAttachmentConfirmApproveCutiTahunan(
                                      args, files!);
                            }
                          }
                        },
                        child: const Icon(Icons.send),
                      ),
                    ],
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
