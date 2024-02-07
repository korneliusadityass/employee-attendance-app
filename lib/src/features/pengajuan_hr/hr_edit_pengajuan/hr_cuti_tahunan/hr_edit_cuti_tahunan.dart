// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/delete_attachment_cuti_tahunan_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/edit_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/get_attachment_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/pengajuan_hr/hr_edit_pengajuan/hr_cuti_tahunan/widget/input_attachment_cuti_tahunan_hr_controller.dart';

import '../../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/attachment_cuti_tahunan_hr_model.dart';
import '../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/detail_cuti_tahunan_model_hr.dart';
import '../../../../core/routes/routes.dart';
import '../../../appbar/custom_appbar_widget.dart';
import '../../../detail/detail_pengajuan/detail_view/cuti_tahunan_detail/widget/cuti_tahunan_download_attachment_controller.dart';
import '../../../detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/confirm_cuti_tahunan_hr_controller.dart';
import '../../../detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/input_attachment_cuti_tahunan_controller.dart';
import '../../../detail/detail_pengajuan_hr/detail_view_hr/cuti_tahunan_detail_hr/widgets/cuti_tahunan_detail_hr_controller.dart';
import '../../cuti_tahunan/widget/hr_cuti_tahunan_list_controller.dart';

class EditCutiTahunanHR extends StatefulWidget {
  const EditCutiTahunanHR({super.key});

  @override
  State<EditCutiTahunanHR> createState() => _EditCutiTahunanHRState();
}

class _EditCutiTahunanHRState extends State<EditCutiTahunanHR> {
  final args = Get.arguments;

  final TextEditingController judulSakit = TextEditingController();
  final TextEditingController namaKaryawan = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController jumlahHariController = TextEditingController();
  final DateFormat formatter = DateFormat("dd/MM/YYYY");
  final formKey = GlobalKey<FormState>();

  final controller = Get.find<DetailViewCutiTahunanHrController>();
  final hrCutiTahunancontroller = Get.find<CutiTahunanHrListController>();
  final confirmCutiTahunanController =
      Get.find<ConfirmCutiTahunanHrController>();
  final inputAttachmentController =
      Get.find<InputAttachmentCutiTahunanHrController>();
  final inputAttachmentConfirmApproveController =
      Get.find<InputattachmentConfirmApproveEditCutiTahunanHrController>();
  final getAttachmentController =
      Get.find<GetAttachmentCutiTahunanHrController>();
  final editCutiTahunanHrController = Get.find<EditCutiTahunanHrController>();
  final deleteAttachmentController =
      Get.find<DeleteAttachmentCutiTahunanHrController>();
  final cutiTahunanDownloadAttachmentController =
      Get.find<DownloadCutiTahunanController>();

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

  Map<String, dynamic> izinSakitList = {};
  List<AttachmentCutiTahunanModelHr> combinedList = [];

  late Future<DetailPengajuanCutiTahunanHrModel> _fetchDataCutiTahunan;
  List<AttachmentCutiTahunanModelHr> resultAttachment = [];

  Future getAttachment(int id) async {
    resultAttachment = await getAttachmentController.attach(args);
    return resultAttachment;
  }

  Future downAttach(int idFile, String fileName, context) async {
    await cutiTahunanDownloadAttachmentController.cutiTahunanDownload(
      idFile,
      fileName,
      context,
    );
  }

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
            return const Text('Error fetching data');
          } else {
            final hasil = snapshot.data!;
            DetailPengajuanCutiTahunanHrModel? data = hasil['value1'];
            List<AttachmentCutiTahunanModelHr> data2 = hasil['value2'];
            namaKaryawan.text = data!.namaKaryawan;
            judulSakit.text = data.judul;
            jumlahHariController.text = data.jumlahHari.toString();

            final dynamic inputDateString = data.tanggalAwal.toString();
            final inputDateFormat = DateFormat('yyyy-MM-dd');
            final outputDateFormat = DateFormat('d/M/y');
            final inputDate = inputDateFormat.parse(inputDateString);
            final outputDateString = outputDateFormat.format(inputDate);
            tglAwalController.text = outputDateString;
            tanggalAPIa = data.tanggalAwal.toString().substring(0, 10);
            final formKey = GlobalKey<FormState>();

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
              ...?files?.map((file) => AttachmentCutiTahunanModelHr(
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
                      'HR Edit Detail Cuti Tahunan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
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
                      height: 15,
                    ),
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
                                  child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Container(
                                                            width: 278,
                                                            height: 270,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white),
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
                                                                    fontSize:
                                                                        16,
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
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    backgroundColor:
                                                                        kRedColor,
                                                                    fixedSize:
                                                                        const Size(
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
                                            icon: const Icon(Icons.download)),
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
                                                                // await deleteAttachmentController
                                                                //     .deleteattachmentCutiTahunanHr(
                                                                //         args,
                                                                //         file[
                                                                //             'id']);
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
                                                                  await deleteAttachmentController
                                                                      .deleteattachmentCutiTahunanHr(
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
                                                Navigator.pop(context);
                                                Get.toNamed(
                                                    Routes.pageCutiTahunanHr);
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
                                  await editCutiTahunanHrController
                                      .editCutiTahunanHr(
                                    args,
                                    judulSakit.text,
                                    tanggalAPIa,
                                    tanggalAPIb,
                                  );
                                  await confirmCutiTahunanController
                                      .confirmCutiTahunanHr(args);
                                }
                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  await hrCutiTahunancontroller.execute();
                                  Get.offNamed(Routes.pageCutiTahunanHr);
                                }
                              } else {
                                if (data.status == 'Draft') {
                                  await editCutiTahunanHrController
                                      .editCutiTahunanHr(
                                    args,
                                    judulSakit.text,
                                    tanggalAPIa,
                                    tanggalAPIb,
                                  );

                                  await confirmCutiTahunanController
                                      .confirmCutiTahunanHr(args);

                                  await inputAttachmentController
                                      .inputAttachmentCutiTahunanHrr(
                                          args, files!);

                                  await hrCutiTahunancontroller.execute();
                                }

                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  await inputAttachmentConfirmApproveController
                                      .inputAttachmentConfirmApproveCutiTahunantHrr(
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
                      () => cutiTahunanDownloadAttachmentController
                              .downloading.value
                          ? LinearProgressIndicator(
                              value: cutiTahunanDownloadAttachmentController
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
