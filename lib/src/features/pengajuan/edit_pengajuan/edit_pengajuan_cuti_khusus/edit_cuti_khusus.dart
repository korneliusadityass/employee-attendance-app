import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../util/navkaryawan.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_attachment_model.dart';
import '../../../../core/model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_detail_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../appbar/custom_appbar_widget.dart';
import '../../cuti_khusus/pengajuan_cuti_khusus.dart';
import 'widget/cuti_khusus_edit_data_controller.dart';

class EditCutiKhusus extends StatefulWidget {
  const EditCutiKhusus({super.key});

  @override
  State<EditCutiKhusus> createState() => _EditCutiKhususState();
}

class _EditCutiKhususState extends State<EditCutiKhusus> {
  final args = Get.arguments;

  final TextEditingController judulcutiController = TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController jumlahHariController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final cutiKhususEditcontroller = Get.find<DetailEditCutiKhususController>();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIAwal = '';
  String tanggalAPIAkhir = '';
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
    var duration = to.difference(from).inHours;
    var durasi = (duration / 24).floor() + 1;
    return durasi;
  }

  void updateJumlahHari() {
    if (startDate != null && endData != null) {
      final difference = daysBetween(startDate!, endData!);
      jumlahHariController.text = difference.toString();
      durasi = difference;
    }
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

  Map<String, dynamic> dataCutiKhusus = {};
  List<Map<String, dynamic>> filesData = [];
  List<CutiKhususAttachmentModel> combinedList = [];

  late Future<DetailCutiKhususModel> _fetchDataCutiKhusus;
  late List<CutiKhususAttachmentModel> resultAttachment;

  Future getAttachment(int id) async {
    resultAttachment = (await cutiKhususEditcontroller.attach(args));

    return resultAttachment;
  }

  Future downAttach(int idFile, String fileName, context) async {
    await cutiKhususEditcontroller.cutiKhususDownload(
        idFile, fileName, context);
  }

  Future<Map<String, dynamic>> getData() async {
    final value1 = await _fetchDataCutiKhusus;
    final value2 = await getAttachment(args);
    return {
      'value1': value1,
      'value2': value2,
    };
  }

  @override
  void initState() {
    super.initState();
    _fetchDataCutiKhusus = cutiKhususEditcontroller.execute(args);
    getAttachment(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavKaryawan(),
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
            DetailCutiKhususModel? data = hasil['value1'];
            List<CutiKhususAttachmentModel> data2 = hasil['value2'];

            judulcutiController.text = data!.judul;
            jumlahHariController.text = data.jumlahHari.toString();

            final dynamic inputDateAwalString = data.tanggalAwal.toString();
            final inputDateAwalFormat = DateFormat('yyyy-MM-dd');
            final outputDateAwalFormat = DateFormat('d/M/y');
            final inputDateAwal =
                inputDateAwalFormat.parse(inputDateAwalString);
            final outputDateAwalString =
                outputDateAwalFormat.format(inputDateAwal);
            tanggalAwalController.text = outputDateAwalString;
            tanggalAPIAwal = data.tanggalAwal.toString().substring(0, 10);

            final dynamic inputDateAkhirString = data.tanggalAkhir.toString();
            final inputDateAkhirFormat = DateFormat('yyyy-MM-dd');
            final outputDateAkhirFormat = DateFormat('d/M/y');
            final inputDateAkhir =
                inputDateAkhirFormat.parse(inputDateAkhirString);
            final outputDateAkhirString =
                outputDateAkhirFormat.format(inputDateAkhir);
            tanggalAkhirController.text = outputDateAkhirString;
            tanggalAPIAkhir = data.tanggalAkhir.toString().substring(0, 10);

            //Attachment
            combinedList = [
              ...data2,
              ...?files?.map((file) => CutiKhususAttachmentModel(
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
                      'Edit Cuti Khusus',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: TextFormField(
                            enabled: data.status == 'Draft',
                            controller: judulcutiController,
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
                                  controller: tanggalAwalController,
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
                                          tanggalAwalController.text =
                                              '$hari/$bulan/$tahun';
                                          tanggalAPIAwal =
                                              '$tahun-$bulan2-$hari';
                                          updateJumlahHari();
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
                          width: 12,
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
                                  controller: tanggalAkhirController,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  validator: endDateValidator,
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

                                          var tahun =
                                              DateFormat.y().format(value);
                                          tanggalAkhirController.text =
                                              '$hari/$bulan/$tahun';
                                          tanggalAPIAkhir =
                                              '$tahun-$bulan-$hari';
                                          updateJumlahHari();
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
                          width: 14,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hari',
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
                                height: 48,
                                child: TextFormField(
                                  enabled: false,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.none,
                                  controller: jumlahHariController,
                                  decoration: InputDecoration(
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: kBlackColor,
                                      width: 1,
                                    )),
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
                                    hintStyle: const TextStyle(
                                      color: kBlackColor,
                                    ),
                                  ),
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
                              .map(
                                (index, file) => MapEntry(
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
                                        if (file.id != null)
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
                                                                  await cutiKhususEditcontroller
                                                                      .cutiKhususDeleteAttachment(
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
                                  ),
                                ),
                              )
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
                              color: kNormalOrangeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PengajuanCutiKhusus(),
                                                  ),
                                                );
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
                            setState(() {});
                            if (formKey.currentState!.validate()) {
                              if (files?.isEmpty ?? true) {
                                if (data.status == 'Draft') {
                                  await cutiKhususEditcontroller.cutiKhususEdit(
                                    args,
                                    judulcutiController.text,
                                    tanggalAPIAwal,
                                    tanggalAPIAkhir,
                                  );

                                  await cutiKhususEditcontroller
                                      .cutiKhususConfirm(args);
                                }
                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  Get.toNamed(Routes.pageCutiKhusus);
                                }
                              } else {
                                if (data.status == 'Draft') {
                                  await cutiKhususEditcontroller.cutiKhususEdit(
                                    args,
                                    judulcutiController.text,
                                    tanggalAPIAwal,
                                    tanggalAPIAkhir,
                                  );
                                  await cutiKhususEditcontroller
                                      .cutiKhususConfirm(args);

                                  await cutiKhususEditcontroller
                                      .cutiKhususInputAttachment(args, files!);
                                }

                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  await cutiKhususEditcontroller
                                      .cutiKhususInputAttachmentConfirmedApproved(
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
                      () => cutiKhususEditcontroller.downloading.value
                          ? LinearProgressIndicator(
                              value:
                                  cutiKhususEditcontroller.progress.value / 100)
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
