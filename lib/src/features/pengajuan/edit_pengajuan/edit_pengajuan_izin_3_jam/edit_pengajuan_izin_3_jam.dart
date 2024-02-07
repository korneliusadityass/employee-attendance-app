import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/attachment_izin_3_jam_model.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/data_pengajuan_izin_3_jam_model.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_izin_3_jam/widgets/detail_izin_3_jam_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan/detail_view/ijin_3_jam_detail/widget/izin_3_jam_detail_controller.dart';
import 'package:project/src/features/pengajuan/edit_pengajuan/edit_pengajuan_izin_3_jam/widgets/edit_pengajuan_izin_3_jam_controller.dart';
import 'package:project/src/features/pengajuan/izin_3_jam/widgets/pengajuan_izin_3_jam_controller.dart';

import '../../../../../util/drawerBuilder.dart';
import '../../../../core/colors/color.dart';
import '../../../appbar/appbar_controller.dart';
import '../../../appbar/custom_appbar_widget.dart';

class EditPengajuanIzin3Jam extends StatefulWidget {
  const EditPengajuanIzin3Jam({super.key});

  @override
  State<EditPengajuanIzin3Jam> createState() => _EditPengajuanIzin3JamState();
}

class _EditPengajuanIzin3JamState extends State<EditPengajuanIzin3Jam> {
  final args = Get.arguments;
  final TextEditingController tglController = TextEditingController();
  final TextEditingController judulIzinController = TextEditingController();
  final TextEditingController startDurasiIzinController =
      TextEditingController();
  final TextEditingController endDurasiIzinController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  // controller section
  final controller = Get.find<DataIzin3JamDetailController>();
  final editPengajuanIzin3JamController = Get.find<EditIzin3JamController>();
  final confirmIzin3JamController = Get.find<ConfirmIzin3JamController>();
  final inputAttachmentIzin3JamController =
      Get.find<InputAttachmentIzin3JamController>();
  final getAttachmentEditIzin3JamController =
      Get.find<GetAttachmentEditIzin3JamController>();
  final deleteAttachmentEditIzin3JamController =
      Get.find<DeleteAttachmentEditIzin3JamController>();
  final inputAttachmentConfirmedApprovedEditIzin3JamController =
      Get.find<InputAttachmentConfirmedApprovedEditIzin3JamController>();
  final izin3JamListController = Get.find<Izin3JamListController>();
  final downloadAttachmentIzin3JamController =
      Get.find<DownloadAttachmentIzin3JamController>();
  final appbarController = Get.find<AppBarController>();
  // controller section

  TimeOfDay _startTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? startWaktu;
  TimeOfDay? endWaktu;
  String tanggalAPI = '';
  final disabledUpload = {'Refused', 'Cancelled'};

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
      startDurasiIzinController.text = '$hasilJam:$hasilMenit';
    }
  }

  void _selectEndTime(context) async {
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
      endDurasiIzinController.text = '$hasilJam:$hasilMenit';
    }
  }

  int getMinutesDiff(TimeOfDay tod1, TimeOfDay tod2) {
    return (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
  }

  String? startTimeValidator(value) {
    if (startWaktu == null) {
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

  Map<String, dynamic> dataIzin3Jam = {};
  List<Map<String, dynamic>> filesData = [];
  List<AttachmentIzin3JamModel> combinedList = [];

  late Future<DataPengajuanIzin3JamModel> _fetchDataIzin3Jam;
  List<AttachmentIzin3JamModel> resultAttachment = [];

  Future getAttachment(int id) async {
    resultAttachment = await getAttachmentEditIzin3JamController.attach(args);

    return resultAttachment;
  }

  Future<Map<String, dynamic>> getData() async {
    final value1 = await _fetchDataIzin3Jam;
    final value2 = await getAttachment(args);
    return {
      'value1': value1,
      'value2': value2,
    };
  }

  Future downAttach(int idFile, String fileName, BuildContext context) async {
    await downloadAttachmentIzin3JamController.downloadAttachment(
        idFile, fileName, context);
  }

  @override
  void initState() {
    super.initState();
    _fetchDataIzin3Jam = controller.execute(args);
    getAttachment(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: DrawerBuilder(
        userMe: appbarController.fetchUserMe(),
      ),
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
            DataPengajuanIzin3JamModel? data = hasil['value1'];
            List<AttachmentIzin3JamModel> data2 = hasil['value2'];
            judulIzinController.text = data!.judul;
            startDurasiIzinController.text = data.waktuAwal.substring(0, 5);
            endDurasiIzinController.text = data.waktuAkhir.substring(0, 5);

            final dynamic inputDateString = data.tanggalIjin.toString();
            final inputDateFormat = DateFormat('yyyy-MM-dd');
            final outputDateFormat = DateFormat('d/M/y');
            final inputDate = inputDateFormat.parse(inputDateString);
            final outputDateString = outputDateFormat.format(inputDate);
            tglController.text = outputDateString;
            tanggalAPI = data.tanggalIjin.toString().substring(0, 10);

            //Format Durasi Awal
            DateFormat inputFormatAwal = DateFormat('HH:mm');
            DateTime dateTimeAwal =
                inputFormatAwal.parse(data.waktuAwal.substring(0, 5));
            TimeOfDay formatDurasiAwal = TimeOfDay.fromDateTime(dateTimeAwal);
            startWaktu = formatDurasiAwal;

            //Format Durasi Akhir
            DateFormat inputFormatAkhir = DateFormat('HH:mm');
            DateTime dateTimeAkhir =
                inputFormatAkhir.parse(data.waktuAkhir.substring(0, 5));
            TimeOfDay formatDurasiAkhir = TimeOfDay.fromDateTime(dateTimeAkhir);
            endWaktu = formatDurasiAkhir;

            //Attachment
            // final filesData = data2.map((data2) {
            //   return {
            //     'id': data2.id,
            //     'path': data2.namaAttachment,
            //   };
            // }).toList();
            combinedList = [
              ...data2,
              ...?files?.map((file) =>
                  AttachmentIzin3JamModel(id: null, namaAttachment: file.path)),
            ];
            inspect(combinedList);
            return StatefulBuilder(
              builder: (context, setState) => Form(
                key: formkey,
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                    bottom: 50,
                  ),
                  children: [
                    const Text(
                      'Edit Izin 3 Jam',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Judul Izin 3 Jam',
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
                        enabled: data.status == 'Draft',
                        controller: judulIzinController,
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
                            width: 90,
                            child: Column(
                              children: [
                                SizedBox(
                                  // height: 55,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Text(
                                      'Tanggal Izin',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 150,
                          ),
                          SizedBox(
                            width: 90,
                            child: Column(
                              children: [
                                SizedBox(
                                  // height: 55,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Text(
                                      'Durasi Izin',
                                      style: TextStyle(
                                        fontSize: 12,
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 35,
                            child: TextFormField(
                              enabled: data.status == 'Draft',
                              controller: tglController,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: kBlackColor,
                                  width: 1,
                                )),
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
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                ).then(
                                  (value) {
                                    try {
                                      var hari = DateFormat.d().format(value!);
                                      var bulan = DateFormat.M().format(value);
                                      var tahun = DateFormat.y().format(value);
                                      tglController.text =
                                          '$hari/$bulan/$tahun';
                                      tanggalAPI = '$tahun-$bulan-$hari';
                                    } catch (e) {
                                      null;
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 95,
                          ),
                          SizedBox(
                            width: 65,
                            height: 35,
                            child: TextFormField(
                              controller: startDurasiIzinController,
                              keyboardType: TextInputType.none,
                              validator: startTimeValidator,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(5),
                              ],
                              decoration: InputDecoration(
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: kBlackColor,
                                  width: 1,
                                )),
                                hintText: '00:00',
                                fillColor: Colors.white24,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                              enabled: data.status == 'Draft',
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
                          SizedBox(
                            width: 65,
                            height: 35,
                            child: TextFormField(
                              enabled: data.status == 'Draft',
                              controller: endDurasiIzinController,
                              keyboardType: TextInputType.none,
                              validator: endTimeValidator,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(5),
                              ],
                              decoration: InputDecoration(
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: kBlackColor,
                                  width: 1,
                                )),
                                hintText: '00:00',
                                fillColor: Colors.white24,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectEndTime(context);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                                                                  await deleteAttachmentEditIzin3JamController
                                                                      .deleteAttachmentEdit3Jam(
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
                      height: 5,
                    ),
                    const SizedBox(
                      height: 20,
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
                                                    Routes.pageIzin3Jam);
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
                            if (formkey.currentState!.validate()) {
                              if (files?.isEmpty ?? true) {
                                if (data.status == 'Draft') {
                                  await editPengajuanIzin3JamController
                                      .editIzin3Jam(
                                    args,
                                    judulIzinController.text,
                                    tanggalAPI,
                                    startDurasiIzinController.text,
                                    endDurasiIzinController.text,
                                  );

                                  await confirmIzin3JamController
                                      .confirmPengajuanIzin3Jam(args);
                                }

                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  Get.toNamed(Routes.pageIzin3Jam);
                                }
                              } else {
                                if (data.status == 'Draft') {
                                  await editPengajuanIzin3JamController
                                      .editIzin3Jam(
                                    args,
                                    judulIzinController.text,
                                    tanggalAPI,
                                    startDurasiIzinController.text,
                                    endDurasiIzinController.text,
                                  );

                                  await confirmIzin3JamController
                                      .confirmPengajuanIzin3Jam(args);

                                  await inputAttachmentIzin3JamController
                                      .inputAttachmentIzin3Jam(args, files!);
                                }

                                if (data.status == 'Approved' ||
                                    data.status == 'Confirmed') {
                                  await inputAttachmentConfirmedApprovedEditIzin3JamController
                                      .inputAttachmentConfirmedApprovedIzin3Jam(
                                          args, files!);
                                }
                              }
                            }
                          },
                          child: const Icon(Icons.send),
                        ),
                      ],
                    )
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
