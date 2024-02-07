import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../util/navhr.dart';
import '../../../../../core/colors/color.dart';
import '../../../../../core/model/approval/cuti_tahunan/cuti_tahunan_attachment_model.dart';
import '../../../../../core/model/approval/cuti_tahunan/izin_sakit_detail_need_confirm_model.dart';
import '../../../../../core/model/cuti_tahunan-model/attachment_cuti_tahunan_model.dart';
import '../../../../../core/model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';
import '../../../../appbar/custom_appbar_widget.dart';
import '../../need_confirm_cuti_tahunan/widgets/need_confirm_cuti_tahunan_controller.dart';
import 'widgets/detail_need_confirm_cuti_tahunan_controller.dart';

class DetailNeedConfirmCutiTahunan extends StatefulWidget {
  const DetailNeedConfirmCutiTahunan({super.key});

  @override
  State<DetailNeedConfirmCutiTahunan> createState() => _DetailNeedConfirmCutiTahunanState();
}

class _DetailNeedConfirmCutiTahunanState extends State<DetailNeedConfirmCutiTahunan> {
  final args = Get.arguments;
  final TextEditingController judulcutiController = TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController jumlahHariController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final disabledUpload = {'Refused', 'Cancelled'};

  final detailNeedConfirmCutiTahunancontroller = Get.find<DetailNeedConfirmCutiTahunanController>();
  final getAttachmentEditCutiTahunanController = Get.find<GetattachmentApprovalCutiTahunanController>();
  final approveRefuseCutiTahunanController = Get.find<NeedConfirmCutiTahunanController>();

  FilePickerResult? result;
  bool isLoading = false;
  List<File>? files;
  int maxFiles = 5;
  int maxFileSize = 10485760;

  String? errorMessage;

  Map<String, dynamic> cutiTahunanList = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  late Future<DetailNeedCutiTahunanModel> _fetchDataCutiTahunan;
  late List<AttachmentNeedConfirmCutiTahunanModel> resultAttachment;

  Future getAttachment(int id) async {
    resultAttachment = await getAttachmentEditCutiTahunanController.attach(args);
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
    _fetchDataCutiTahunan = detailNeedConfirmCutiTahunancontroller.execute(args);
    getAttachment(args);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
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
                DetailNeedCutiTahunanModel? data = hasil['value1'];
                AttachmentCutiTahunanModel? data2 = hasil['value2'];
                judulcutiController.text = data!.judul;
                jumlahHariController.text = data.jumlahHari.toString();

                final dynamic inputDateAwalString = data.tanggalAwal.toString();
                final inputDateAwalFormat = DateFormat('yyyy-MM-dd');
                final outputDateAwalFormat = DateFormat('d/M/y');
                final inputDateAwal = inputDateAwalFormat.parse(inputDateAwalString);
                final outputDateAwalString = outputDateAwalFormat.format(inputDateAwal);
                tanggalAwalController.text = outputDateAwalString;

                final dynamic inputDateAkhirString = data.tanggalAkhir.toString();
                final inputDateAkhirFormat = DateFormat('yyyy-MM-dd');
                final outputDateAkhirFormat = DateFormat('d/M/y');
                final inputDateAkhir = inputDateAkhirFormat.parse(inputDateAkhirString);
                final outputDateAkhirString = outputDateAkhirFormat.format(inputDateAkhir);
                tanggalAkhirController.text = outputDateAkhirString;

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
                        'Detail NeedConfirm Cuti Tahunan',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Judul Cuti Tahunan',
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
                          keyboardType: TextInputType.none,
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
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: tanggalAwalController,
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
                                    onTap: () {},
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
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: tanggalAkhirController,
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
                                    onTap: () {},
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
                                                    child: Text('${index + 1}. ${file['path'].split('/').last}'),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      // downloadAttachment(
                                                      //   index,
                                                      //   file['path'],
                                                      // );
                                                    },
                                                    icon: const Icon(Icons.download),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(108, 22),
                              backgroundColor: kLightRedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              await approveRefuseCutiTahunanController.cutiTahunanRefuse(data.id);
                            },
                            child: const Text(
                              'Refuse',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kBlackColor),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(108, 22),
                              backgroundColor: kLightGreenColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              await approveRefuseCutiTahunanController.cutiTahunanApproved(data.id);
                            },
                            child: const Text(
                              'Approve',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kBlackColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ));
    });
  }
}
