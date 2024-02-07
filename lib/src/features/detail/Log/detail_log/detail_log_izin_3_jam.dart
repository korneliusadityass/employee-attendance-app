import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/src/core/model/approval/izin_3_jam/attachment_need_confirm_izin_jam_model.dart';
import 'package:project/src/core/model/approval/izin_3_jam/data_need_confirm_izin_3_jam_model.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/attachment_izin_3_jam_model.dart';
import 'package:project/src/features/detail/need_aprrove/detail_need_approve/detail_need_confirm_3_jam/widgets/detail_need_confirm_3_jam_controller.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../appbar/custom_appbar_widget.dart';
import '../../detail_pengajuan_hr/detail_view_hr/izin_3_jam_detail_hr/widgets/hr_izin_3_jam_detail_controller.dart';

class DetailLogIzin3Jam extends StatefulWidget {
  const DetailLogIzin3Jam({super.key});

  @override
  State<DetailLogIzin3Jam> createState() => _DetailLogIzin3JamState();
}

class _DetailLogIzin3JamState extends State<DetailLogIzin3Jam> {
  final args = Get.arguments;
  final TextEditingController tglController = TextEditingController();
  final TextEditingController judulIzinController = TextEditingController();
  final TextEditingController startDurasiIzinController =
      TextEditingController();
  final TextEditingController endDurasiIzinController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  final controller = Get.find<DetailNeedConfirm3JamController>();
  final hrGetAttachmentEditIzin3JamController =
      Get.find<HrGetAttachmentEditIzin3JamController>();
  final hrDownloadAttachmentIzin3JamController =
      Get.find<HrDownloadAttachmentIzin3JamController>();

  TimeOfDay _startTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? startWaktu;
  TimeOfDay? endWaktu;
  String tanggalAPI = '';
  final disabledUpload = {'Refused', 'Cancelled'};

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (newTime != null) {
      setState(
        () {
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
        },
      );
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (newTime != null) {
      setState(
        () {
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
        },
      );
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

  Map<String, dynamic> dataIzin3Jam = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  late Future<DataNeedConfirmIzin3JamModel> _fetchDataIzin3Jam;
  late List<AttachmentNeedConfirmIzin3JamModel> resultAttachment;

  Future getAttachment(int id) async {
    resultAttachment = await hrGetAttachmentEditIzin3JamController.attach(args);
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
    await hrDownloadAttachmentIzin3JamController.downloadAttachment(
      idFile,
      fileName,
      context,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDataIzin3Jam = controller.execute(args);
    getAttachment(args);
  }

  // TEST

  // Kombinasi Attachment

  // Kombinasi Attachment

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
              DataNeedConfirmIzin3JamModel? data = hasil['value1'];
              AttachmentIzin3JamModel? data2 = hasil['value2'];
              judulIzinController.text = data!.judul;
              startDurasiIzinController.text = data.waktuAwal.substring(0, 5);
              endDurasiIzinController.text = data.waktuAkhir.substring(0, 5);

              final dynamic inputDateString = data.tanggalIjin.toString();
              final inputDateFormat = DateFormat('yyyy-MM-dd');
              final outputDateFormat = DateFormat('d/M/y');
              final inputDate = inputDateFormat.parse(inputDateString);
              final outputDateString = outputDateFormat.format(inputDate);
              tglController.text = outputDateString;

              // Attachment
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
                      'Detail Log Izin 3 Jam',
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
                        enabled: false,
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
                              enabled: false,
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
                              enabled: false,
                              onTap: _selectStartTime,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 65,
                            height: 35,
                            child: TextFormField(
                              enabled: false,
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
                              onTap: _selectEndTime,
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

                                                    var status =
                                                        await Permission.storage
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
                                                                child:
                                                                    Container(
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
                                                                            top:
                                                                                Radius.circular(8),
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
                                                                        size:
                                                                            80,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      const Text(
                                                                        'Tidak mendapatkan akses\nuntuk menulis file',
                                                                        textAlign:
                                                                            TextAlign.center,
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
                                                  icon: const Icon(
                                                      Icons.download),
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
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
