// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';
import 'package:project/src/features/appbar/custom_appbar_widget.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/delete_attachment_izin_sakit_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/edit_izin_sakit_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_edit_izin_sakit/widget/get_attachment_izin_sakit_hr_controller.dart';

import '../../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/pengajuan_pembatalan/izin_sakit_model/detail_pengajuan_izin_sakit_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../detail/detail_pengajuan/detail_view/izin_sakit_detail/widget/izin_sakit_download_attachment_modal.dart';
import '../../../detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/confirm_izin_sakit_hr_controller.dart';
import '../../../detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/detail_izin_sakit_hr_controller.dart';
import '../../../detail/detail_pengajuan_hr/detail_izin_sakit_hr/widget/input_attachment_izin_sakit_hr_controller.dart';
import '../../../pengajuan/edit_pengajuan/edit_pengajuan_izin_sakit/widget/input_attachment_izin_sakit_confirm_approve_controller.dart';
import '../../izin_sakit/widget/hr_izin_sakit_list_controller.dart';
// import '../pengajuan_pembatalan_izin_sakit.dart';

class EditIzinSakitHR extends StatefulWidget {
  // final int id;
  const EditIzinSakitHR({super.key});

  @override
  State<EditIzinSakitHR> createState() => _EditIzinSakitHRState();
}

class _EditIzinSakitHRState extends State<EditIzinSakitHR> {
  final args = Get.arguments;
  final TextEditingController judulSakit = TextEditingController();
  final TextEditingController namaKaryawan = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final DateFormat formatter = DateFormat("dd/MM/YYYY");
  final formKey = GlobalKey<FormState>();

  final controller = Get.find<DetailIzinSakitHrController>();
  final confirmizinSakitHrController = Get.find<ConfirmIzinSakitHrController>();
  final inputattchmentController =
      Get.find<InputAttachmentIzinSakitHrController>();
  final inputAttchmentConfirmApproveController =
      Get.find<InputAttachmentConfirmedApprovedEditIzinSakitController>();
  final getAttchmentHrController =
      Get.find<GetAttachmentIzinSakitHrController>();
  final hrEditController = Get.find<EditIzinSakitHrController>();
  final deleteAttchmentController =
      Get.find<DeleteAtttchmentIzinSakitHrController>();
  final hrIzinSakitcontroller = Get.find<HrIzinSakitListController>();
  final izinSakitDownloadAttachmentController =
      Get.find<DownloadIzinSakitController>();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIa = '';
  String tanggalAPIb = '';

  final disabledUpload = {'Refused', 'Cancelled'};
  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal!";
    }
    if (startDate == null && endData != null) {
      return 'isi tanggal awal';
    }
    if (endData != null && endData!.isBefore(startDate!)) {
      return "tanggal akhir setelah tanggal awal";
    }
    return null;
  }

  FilePickerResult? result;
  bool isLoading = false;
  List<File>? files;
  int maxFiles = 5;
  int maxFileSize = 10485760;
  String? errorMessage;

  void pickFile() async {
    try {
      isLoading = true;

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
          errorMessage = 'File yang diperbolehkan hanya 10mb';
        } else if ((files?.length ?? 0) + newFiles.length <= maxFiles) {
          files ??= [];
          files!.addAll(newFiles);
          debugPrint('Selected files: $files');

          errorMessage = null;
        } else {
          debugPrint('File telah mencapai batas');

          errorMessage = 'File telah mencapai batas';

          // Add only the first 5 files if more than 5 files are selected
          int maxNewFiles = maxFiles - (files?.length ?? 0);
          if (maxNewFiles > 0) {
            files ??= [];
            files!.addAll(newFiles.take(maxNewFiles));
          }
        }
      }
      isLoading = false;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Map<String, dynamic> izinSakitListHR = {};
  List<AttachmentIzinSakitModel> combinedList = [];

  late Future<DetailPengajuanIzinSakitModel> _fetchDataIzinSakitHr;
  List<AttachmentIzinSakitModel> resultAttachment = [];

  Future getAttachment(int id) async {
    resultAttachment = await getAttchmentHrController.attach(args);
    print(resultAttachment);
    return resultAttachment;
  }

  Future downAttach(int idFile, String fileName, context) async {
    await izinSakitDownloadAttachmentController.IzinSakitDownload(
        idFile, fileName, context);
  }

  Future<Map<String, dynamic>> getData() async {
    final value1 = await _fetchDataIzinSakitHr;
    final value2 = await getAttachment(args);
    return {
      'value1': value1,
      'value2': value2,
    };
  }

  @override
  void initState() {
    super.initState();
    _fetchDataIzinSakitHr = controller.execute(args);
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
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            final hasil = snapshot.data!;
            DetailPengajuanIzinSakitModel? data = hasil['value1'];
            List<AttachmentIzinSakitModel> data2 = hasil['value2'];
            print('ini data 2 $data2');
            namaKaryawan.text = data!.namaKaryawan;
            judulSakit.text = data.judul;

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
            final inputDate2 = inputDateFormat.parse(inputDateString);
            final outputDateString2 = outputDateFormat.format(inputDate);
            tglAkhirController.text = outputDateString;
            tanggalAPIb = data.tanggalAkhir.toString().substring(0, 10);

            //Attachment
            combinedList = [
              ...data2,
              ...?files?.map((file) => AttachmentIzinSakitModel(
                  id: null, namaAttachment: file.path)),
            ];
            inspect(combinedList);
            return StatefulBuilder(
              builder: (context, setState) => Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  children: [
                    const Text(
                      'HR Edit Detail Izin Sakit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Nama Karyawan',
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
                        enabled: false,
                        controller: namaKaryawan,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Judul Izin Sakit',
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
                            controller: judulSakit,
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
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tanggal Awal',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
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
                        const SizedBox(
                          width: 19,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tanggal Akhir',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
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
                              : TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: kBlueColor,
                                  ),
                                  onPressed: () {
                                    disabledUpload.contains(data.status)
                                        ? null
                                        : pickFile();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.cloud_upload_rounded,
                                        color: kWhiteColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
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
                        const SizedBox(
                          height: 12,
                        ),
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: combinedList
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
                                                '${index + 1}. ${file.namaAttachment.split('/').last}')),
                                        IconButton(
                                          onPressed: () async {
                                            if (!Platform.isAndroid) {
                                              return;
                                            }

                                            var status = await Permission
                                                .storage
                                                .request();

                                            if (status.isPermanentlyDenied) {
                                              var newStatus = await Permission
                                                  .manageExternalStorage
                                                  .request();
                                              if (!newStatus.isRestricted) {
                                                status = newStatus;
                                              }
                                            }

                                            if (status.isGranted) {
                                              if (context.mounted) {
                                                downAttach(
                                                  file.id!,
                                                  file.namaAttachment,
                                                  context,
                                                );
                                              }
                                            }

                                            if (status.isPermanentlyDenied) {
                                              if (context.mounted) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Container(
                                                          width: 278,
                                                          height: 270,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.white),
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
                                                                  color:
                                                                      kRedColor,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              const Icon(
                                                                Icons
                                                                    .warning_amber,
                                                                color:
                                                                    kRedColor,
                                                                size: 80,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              const Text(
                                                                'Tidak mendapatkan akses\nuntuk menulis file',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 16,
                                                                  color:
                                                                      kBlackColor,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 24,
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  backgroundColor:
                                                                      kRedColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          120,
                                                                          45),
                                                                ),
                                                                onPressed: () {
                                                                  openAppSettings();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Buka Setting',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Container(
                                                    width: 278,
                                                    height: 270,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 31,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(8),
                                                            ),
                                                            color: kRedColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        const Icon(
                                                          Icons.warning,
                                                          color: kRedColor,
                                                          size: 80,
                                                        ),
                                                        const SizedBox(
                                                          height: 7,
                                                        ),
                                                        const Text(
                                                          'Apakah yakin ingin\nmenghapus file ini ?\nFile akan langsung hilang',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 16,
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
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xff949494),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color:
                                                                      kWhiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 34,
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
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
                                                                if (file.id ==
                                                                    null) {
                                                                  combinedList
                                                                      .removeAt(
                                                                          index);
                                                                  files!.removeWhere(
                                                                      (element) {
                                                                    return element
                                                                            .path ==
                                                                        file.namaAttachment;
                                                                  });

                                                                  print(
                                                                      'ISI COMBINED LIST $combinedList');
                                                                  print(
                                                                      'files : $files');
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text(
                                                                          'File telah dihapus'),
                                                                    ),
                                                                  );
                                                                  if (mounted) {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                } else {
                                                                  if (mounted) {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                  await deleteAttchmentController
                                                                      .deleteAttachmentIzinSakitttHr(
                                                                          args,
                                                                          file.id!);
                                                                  combinedList.removeWhere(
                                                                      (element) =>
                                                                          element
                                                                              .id ==
                                                                          file.id);
                                                                }
                                                                setState(() {});
                                                              },
                                                              child: const Text(
                                                                'Ya',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                        const SizedBox(
                          height: 5,
                        ),
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
                              fontWeight: FontWeight.w900,
                              color: kBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                                          'Apakah yakin ingin kembali\nhal yang anda edit tidak akan tersimpan ?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
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
                                                fixedSize:
                                                    const Size(100, 35.81),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: kWhiteColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 34,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                backgroundColor:
                                                    const Color(0xffFFF068),
                                                fixedSize:
                                                    const Size(100, 35.81),
                                              ),
                                              onPressed: () {
                                                Get.toNamed(
                                                    Routes.pageIzinSakittHr);
                                              },
                                              child: const Text(
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
                          child: const Icon(Icons.cancel_outlined),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreenColor,
                            fixedSize: const Size(
                              90,
                              29,
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (files?.isEmpty ?? true) {
                                if (data.status == 'Draft') {
                                  await hrEditController.editIzinSakitHr(
                                    args,
                                    judulSakit.text,
                                    tanggalAPIa,
                                    tanggalAPIb,
                                  );
                                  await confirmizinSakitHrController
                                      .confirmIzinSakitHr(args);
                                }
                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  await hrIzinSakitcontroller.execute();
                                  Get.offNamed(Routes.pageIzinSakittHr);
                                }
                              } else {
                                if (data.status == 'Draft') {
                                  await hrEditController.editIzinSakitHr(
                                    args,
                                    judulSakit.text,
                                    tanggalAPIa,
                                    tanggalAPIb,
                                  );

                                  await confirmizinSakitHrController
                                      .confirmIzinSakitHr(args);

                                  await inputattchmentController
                                      .inputAttachmentizinsakitHr(args, files!);

                                  await hrIzinSakitcontroller.execute();
                                }

                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  await inputAttchmentConfirmApproveController
                                      .inputAttachmentConfirmApproveIzinSakit(
                                          args, files!);
                                }
                              }
                            }
                          },
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                    Obx(
                      () => izinSakitDownloadAttachmentController
                              .downloading.value
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
              ),
            );
          }
        },
      ),
    );
  }
}
