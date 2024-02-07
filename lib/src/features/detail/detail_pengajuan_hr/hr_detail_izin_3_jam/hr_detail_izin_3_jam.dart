import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/izin_3_jam/data_hr_detail_izin_3_jam_model.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/hr_detail_izin_3_jam/widgets/hr_detail_izin_3_jam_controller.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../appbar/custom_appbar_widget.dart';

class HRDetailIzin3Jam extends StatefulWidget {
  const HRDetailIzin3Jam({super.key});

  @override
  State<HRDetailIzin3Jam> createState() => _HRDetailIzin3JamState();
}

class _HRDetailIzin3JamState extends State<HRDetailIzin3Jam> {
  final args = Get.arguments;
  final TextEditingController tglController = TextEditingController();
  final TextEditingController judulIzinController = TextEditingController();
  final TextEditingController startDurasiIzinController =
      TextEditingController();
  final TextEditingController endDurasiIzinController = TextEditingController();
  final TextEditingController namaKaryawanController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  final controller = Get.find<HrDataIzin3JamController>();
  final hrDeleteIzin3JamController = Get.find<HrDeleteIzin3JamController>();
  final hrConfirmIzin3JamController = Get.find<HrConfirmIzin3JamController>();
  final hrInputAttachmentIzin3JamController =
      Get.find<HrInputAttachmentIzin3JamController>();

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
  List<File>? _files;
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
        } else if ((_files?.length ?? 0) + newFiles.length <= maxFiles) {
          _files ??= [];
          _files!.addAll(newFiles);
          debugPrint('Selected files: $_files');

          errorMessage = null;
        } else {
          debugPrint('File telah mencapai batas');

          errorMessage = 'File telah mencapai batas';

          // Add only the first 5 files if more than 5 files are selected
          int maxNewFiles = maxFiles - (_files?.length ?? 0);
          if (maxNewFiles > 0) {
            _files ??= [];
            _files!.addAll(newFiles.take(maxNewFiles));
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
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  // TEST

  late Future<HrDataDetailIzin3JamModel> _fetchDataPengajuanIzin3Jam;

  @override
  void initState() {
    super.initState();
    _fetchDataPengajuanIzin3Jam = controller.execute(args);
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
          future: _fetchDataPengajuanIzin3Jam,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return const Center(
                child: SpinKitFadingFour(
                  size: 20,
                  color: Colors.amber,
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Error fetching data');
            } else {
              HrDataDetailIzin3JamModel data = snapshot.data!;
              namaKaryawanController.text = data.namaKaryawan;
              judulIzinController.text = data.judul;
              startDurasiIzinController.text = data.waktuAwal.substring(0, 5);
              endDurasiIzinController.text = data.waktuAkhir.substring(0, 5);

              final dynamic inputDateString = data.tanggalIjin.toString();
              final inputDateFormat = DateFormat('yyyy-MM-dd');
              final outputDateFormat = DateFormat('d/M/y');
              final inputDate = inputDateFormat.parse(inputDateString);
              final outputDateString = outputDateFormat.format(inputDate);
              tglController.text = outputDateString;
              tanggalAPI = data.tanggalIjin.toString().substring(0, 10);
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
                      'HR Detail Izin 3 Jam',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                        controller: namaKaryawanController,
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Column(
                              children: const [
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
                          const SizedBox(
                            width: 150,
                          ),
                          SizedBox(
                            width: 90,
                            child: Column(
                              children: const [
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
                              : TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: kBlueColor,
                                  ),
                                  onPressed: () {
                                    disabledUpload
                                            .contains(dataIzin3Jam['status'])
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
                        if (_files != null)
                          ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: _files!
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
                                                  '${index + 1}. ${file.path.split('/').last}')),
                                          IconButton(
                                            onPressed: () {
                                              _files!.removeAt(index);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'File telah dihapus'),
                                                ),
                                              );
                                              setState(() {});
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
                                    height: 250,
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
                                          'Apakah yakin ingin\nmenghapus pengajuan ini ?',
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
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await hrDeleteIzin3JamController
                                                    .deletePengajuanIzin3Jam(
                                                        args);
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
                          child: const Icon(Icons.delete),
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
                            if (_files?.isEmpty ?? true) {
                              print('kosongan bang');
                              await hrConfirmIzin3JamController
                                  .confirmPengajuanIzin3Jam(args);
                            } else {
                              print('ada isinya bang');
                              await hrInputAttachmentIzin3JamController
                                  .inputAttachmentIzin3Jam(args, _files!);
                              await hrConfirmIzin3JamController
                                  .confirmPengajuanIzin3Jam(args);
                            }
                          },
                          child: const Icon(Icons.send),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
