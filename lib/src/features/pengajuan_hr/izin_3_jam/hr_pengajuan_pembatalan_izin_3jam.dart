import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/cuti_khusus/hr_list_karyawan_model.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/izin_3_jam/list_hr_izin_3_jam_model.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/hr_detail_izin_3_jam/widgets/hr_detail_izin_3_jam_controller.dart';
import 'package:project/src/features/pengajuan_hr/izin_3_jam/widgets/hr_pengajuan_pembatalan_izin_3_jam_controller.dart';

import '../../../../util/navhr.dart';
import '../../../core/colors/color.dart';
import '../../appbar/custom_appbar_widget.dart';

String judulIzin3Jam = '';
String durasiWaktuMulai = '';
String durasiWaktuSelesai = '';
String tanggalIzin3Jam = '';

class HRPengajuanIzin3Jam extends GetView<ListIzin3JamHrController> {
  HRPengajuanIzin3Jam({super.key});

  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController tglFormController = TextEditingController();
  final TextEditingController startDurasiIzinController =
      TextEditingController();
  final TextEditingController endDurasiIzinController = TextEditingController();
  final TextEditingController judulIzinController = TextEditingController();
  final TextEditingController hariController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController namaKaryawanController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final hrPengajuanIzin3JamController =
      Get.find<HrPengajuanIzin3JamController>();
  final hrListKaryawanController = Get.find<HrListKaryawanController>();
  final hrDeleteIzin3JamController = Get.find<HrDeleteIzin3JamController>();
  final hrCancelPengajuanIzin3JamController =
      Get.find<HrCancelPengajuanIzin3JamController>();
  int? selectedId;
  DateTime? endData;
  DateTime? startDate;
  String tanggalAPI = '';

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

  TimeOfDay _startTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? startWaktu;
  TimeOfDay? endWaktu;

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

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;
  // AREA TABLE CONTOH
  List<dynamic> dataIzin3Jam = [];

  Future fetchData() async {
    return controller.dataIzin3Jam.value = await controller.execute(
      page: page,
      filterStatus: chosevalue,
      size: pageSize,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    controller.pageNum.value = newPage;
    fetchData();
  }
  // AREA TABLE

  int? idIjin;

  Future kirimData() async {
    hrPengajuanIzin3JamController.pengajuan(
      selectedId!,
      judulIzinController.text,
      tanggalAPI,
      startDurasiIzinController.text,
      endDurasiIzinController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchData();
        },
        child: ListView(
          padding: const EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: 50,
          ),
          children: [
            const Text(
              'HR Izin 3 Jam',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: kBlueColor,
                    fixedSize: const Size(147, 23)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: formkey,
                            child: Container(
                              width: 320,
                              height: 520,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'FORM PEMBUATAN IZIN 3 JAM',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Nama Karyawan',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 270,
                                      height: 60,
                                      child: TypeAheadFormField<dynamic>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller: namaKaryawanController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: kBlackColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        suggestionsCallback: (pattern) async {
                                          List<HrListKaryawanModel>
                                              suggestions =
                                              hrListKaryawanController
                                                  .dataKaryawan
                                                  .where((suggestion) {
                                            // Customize the logic here to match the suggestion based on the pattern
                                            return suggestion.namaKaryawan
                                                .toLowerCase()
                                                .contains(
                                                    pattern.toLowerCase());
                                          }).toList();

                                          return suggestions;
                                        },
                                        itemBuilder:
                                            (context, dynamic suggestion) {
                                          HrListKaryawanModel suggestionData =
                                              suggestion;
                                          String namaKaryawan =
                                              suggestionData.namaKaryawan;
                                          return ListTile(
                                            title: Text(namaKaryawan),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (dynamic suggestion) {
                                          HrListKaryawanModel suggestionData =
                                              suggestion;
                                          selectedId = suggestionData.id;
                                          String namaKaryawan =
                                              suggestionData.namaKaryawan;
                                          namaKaryawanController.text =
                                              namaKaryawan;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Masukkan Nama Karyawan';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Judul Izin 3 Jam',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   height: 5,
                                    // ),
                                    SizedBox(
                                      width: 270,
                                      height: 60,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: judulIzinController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Masukkan judul izin';
                                          }
                                          if (value.length > 30) {
                                            return 'judul maksimal 30 karakter';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Tanggal Izin',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 270,
                                      height: 60,
                                      child: TextFormField(
                                        controller: tglFormController,
                                        keyboardType: TextInputType.none,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'tanggal harus diisi';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          // hintText: 'tanggal awal',
                                          fillColor: Colors.white24,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 10, 0, 5),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
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
                                                var hari = DateFormat.d()
                                                    .format(value!);
                                                var bulan2 = DateFormat.M()
                                                    .format(value);
                                                var tahun = DateFormat.y()
                                                    .format(value);
                                                tglFormController.text =
                                                    '$hari/$bulan2/$tahun';
                                                tanggalAPI =
                                                    '$tahun-$bulan2-$hari';
                                              } catch (e) {
                                                null;
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Start Durasi',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 270,
                                      height: 60,
                                      child: TextFormField(
                                        controller: startDurasiIzinController,
                                        keyboardType: TextInputType.none,
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(5),
                                        ],
                                        validator: startTimeValidator,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: '00:00',
                                          fillColor: Colors.white24,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 10, 0, 10),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ),
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
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'End Durasi',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 270,
                                      height: 60,
                                      child: TextFormField(
                                        controller: endDurasiIzinController,
                                        keyboardType: TextInputType.none,
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(5),
                                        ],
                                        onTap: () {
                                          setState(() {
                                            _selectEndTime(context);
                                          });
                                        },
                                        validator: endTimeValidator,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: '00:00',
                                          fillColor: Colors.white24,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 10, 0, 10),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: kBlackColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 35,
                                        right: 35,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(84, 29),
                                                backgroundColor:
                                                    kLightGrayColor,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Batal',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(84, 29),
                                                backgroundColor: kBlueColor,
                                              ),
                                              onPressed: () async {
                                                setState(() {});
                                                if (formkey.currentState!
                                                    .validate()) {
                                                  await kirimData();
                                                }
                                              },
                                              child: const Text(
                                                'Save',
                                                textAlign: TextAlign.center,
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
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'Buat Izin 3 Jam',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Expanded(
                  child: SizedBox(
                    width: 149,
                    child: Text(
                      'Tanggal Awal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: SizedBox(
                    width: 149,
                    height: 48,
                    child: TextFormField(
                      keyboardType: TextInputType.none,
                      controller: tglAwalController,
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
                              var hari = DateFormat.d().format(value!);
                              var bulan = DateFormat.M().format(value);
                              var tahun = DateFormat.y().format(value);
                              tglAwalController.text = '$hari/$bulan/$tahun';
                              tglAwal = '$tahun-$bulan-$hari';
                              fetchData();
                            } catch (e) {
                              null;
                            }
                          },
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'tanggal',
                        fillColor: Colors.white24,
                        filled: true,
                        suffixIcon: const Icon(Icons.date_range_outlined),
                        contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
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
                const Expanded(
                  child: SizedBox(
                    width: 149,
                    child: Text(
                      'Tanggal Akhir',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: SizedBox(
                    width: 149,
                    height: 48,
                    child: TextFormField(
                      keyboardType: TextInputType.none,
                      controller: tglAkhirController,
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

                              var hari = DateFormat.d().format(value!);
                              var bulan = DateFormat.M().format(value);

                              var tahun = DateFormat.y().format(value);
                              tglAkhirController.text = '$hari/$bulan/$tahun';
                              tglAkhir = '$tahun-$bulan-$hari';
                              fetchData();
                            } catch (e) {
                              null;
                            }
                          },
                        );
                      },
                      validator: endDateValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'tanggal',
                        fillColor: Colors.white24,
                        filled: true,
                        suffixIcon: const Icon(Icons.date_range_outlined),
                        contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
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
                  child: SizedBox(
                    width: 149,
                    child: GetBuilder<ListIzin3JamHrController>(
                      builder: (controller) {
                        return DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 10, 10, 5),
                            hintText: 'Status',
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kBlackColor)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kLightGreenColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kWhiteColor,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          value: chosevalue,
                          items: <String>[
                            'All',
                            'Draft',
                            'Confirmed',
                            'Approved',
                            'Refused',
                            'Cancelled',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            chosevalue = value.toString();
                            chosevalue = value!;
                            controller.filterStatus2.value = chosevalue;
                            fetchData();
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: SizedBox(
                    width: 149,
                    height: 48,
                    child: GetBuilder<ListIzin3JamHrController>(
                      builder: (controller) {
                        return DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 10, 10, 5),
                            hintText: 'Show',
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kBlackColor)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kLightGreenColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: kWhiteColor,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          value: chosevaluedua,
                          items: <String>[
                            '10',
                            '20',
                            '50',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            // setState(
                            //   () {
                            //     chosevaluedua = value!;
                            //     pageSize = int.parse(chosevaluedua);
                            //     fetchData();
                            //   },
                            // );
                            chosevaluedua = value.toString();
                            chosevaluedua = value!;
                            pageSize = int.parse(chosevaluedua);
                            controller.pageSize.value =
                                int.parse(chosevaluedua);
                            fetchData();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => SingleChildScrollView(
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
                      'Nama Karyawan',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      'Judul Izin 3 Jam',
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
                      'Durasi Izin',
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
                    )),
                  ],
                  rows: controller.isFetchData.value
                      ? [
                          const DataRow(
                            cells: [
                              DataCell(CircularProgressIndicator()),
                              DataCell(Text('Loading...')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                            ],
                          ),
                        ]
                      : List<DataRow>.generate(
                          controller.dataIzin3Jam.length,
                          (int index) {
                            // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                            ListHrIzin3JamModel data =
                                controller.dataIzin3Jam[index];

                            int rowIndex = (controller.pageNum.value - 1) *
                                    controller.pageSize.value +
                                index +
                                1;
                            return DataRow(
                              onLongPress: () {
                                // Navigate to another page with the id obtained from the API
                                Get.toNamed(Routes.pageHrIzin3JamDetail,
                                    arguments: data.id);
                              },
                              cells: [
                                DataCell(Text(rowIndex.toString())),
                                DataCell(Text(data.namaKaryawan)),
                                DataCell(Text(data.judul)),
                                DataCell(Text(data.tanggalIjin
                                    .toString()
                                    .substring(0, 10))),
                                DataCell(
                                  Text(
                                      '${data.waktuAwal.substring(0, 5)} - ${data.waktuAkhir.substring(0, 5)}'),
                                ),
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
                                              onPressed: () {
                                                // Navigate to another page with the id obtained from the API
                                                Get.toNamed(
                                                  Routes.pageHrEditIzin3Jam,
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
                                                                .circular(8),
                                                      ),
                                                      child: Container(
                                                        width: 278,
                                                        height: 270,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white,
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
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
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
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
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
                                                                          FontWeight
                                                                              .w400,
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
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xffFFF068),
                                                                    fixedSize:
                                                                        const Size(
                                                                            100,
                                                                            35.81),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    await hrDeleteIzin3JamController
                                                                        .deletePengajuanIzin3Jam(
                                                                            data.id);
                                                                    await fetchData();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Ya',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
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
                                                  onPressed: () {
                                                    // Navigate to another page with the id obtained from the API
                                                    Get.toNamed(
                                                      Routes.pageHrEditIzin3Jam,
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
                                                                  'Apakah anda yakin\nmengcancel pengajuan ini?',
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
                                                                        await hrCancelPengajuanIzin3JamController
                                                                            .cancelIzin3Jam(data.id);
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
                                                  onPressed: () {
                                                    // Navigate to another page with the id obtained from the API
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         EditPengajuanIzin3Jam(
                                                    //       id: dataIzin3Jam[index]
                                                    //           ['id'],
                                                    //     ),
                                                    //   ),
                                                    // );
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
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left),
                    onPressed: controller.pageNum.value > 1
                        ? () => onPageChange(controller.pageNum.value - 1)
                        : null,
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
                            '${controller.pageNum.value}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: kWhiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )),
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right),
                    onPressed: controller.dataIzin3Jam.length >=
                            controller.pageSize.value
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
