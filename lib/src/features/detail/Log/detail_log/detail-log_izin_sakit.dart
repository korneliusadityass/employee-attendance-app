import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/approval/izin_sakit/izin_sakit_attachment_model.dart';
import '../../../../core/model/approval/izin_sakit/izin_sakit_detail_need_confirm_model.dart';
import '../../../../core/model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';
import '../../../appbar/custom_appbar_widget.dart';
import '../../need_aprrove/detail_need_approve/detail_need_confirm_izin_sakit/widgets/detail_need_confirm_izin_sakit.dart';

class IzinSakitDetailLog extends StatefulWidget {
  const IzinSakitDetailLog({super.key});

  @override
  State<IzinSakitDetailLog> createState() => _IzinSakitDetailLogState();
}

class _IzinSakitDetailLogState extends State<IzinSakitDetailLog> {
  final args = Get.arguments;
  final TextEditingController judulSakit = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  // final TextEditingController jumlahHariController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final disabledUpload = {'Refused', 'Cancelled'};

  final detailLogIzinSakitController = Get.find<DetailNeedConfirmIzinSakitController>();
  final getAttachmentEditIzinSakitController = Get.find<GetattachmentApprovalIzinSakitController>();

  FilePickerResult? result;
  bool isLoading = false;
  List<File>? files;
  int maxFiles = 5;
  int maxFileSize = 10485760;

  String? errorMessage;

  Map<String, dynamic> izinSakitList = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  late Future<DetailNeedIzinSakitModel> _fetchDataIzinSakit;
  late List<AttachmentNeedConfirmIzinSakitModel> resultAttachment;

  Future getAttachment(int id) async {
    resultAttachment = await getAttachmentEditIzinSakitController.attach(args);
  }

  Future<Map<String, dynamic>> getData() async {
    final value1 = await _fetchDataIzinSakit;
    final value2 = await getAttachment(args);
    return {
      'value1': value1,
      'value2': value2,
    };
  }

  @override
  void initState() {
    super.initState();
    _fetchDataIzinSakit = detailLogIzinSakitController.execute(args);
    getAttachment(args);
  }

  @override
  Widget build(BuildContext context) {
    print(izinSakitList);

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
              DetailNeedIzinSakitModel? data = hasil['value1'];
              AttachmentIzinSakitModel? data2 = hasil['value2'];
              judulSakit.text = data!.judul;

              final dynamic inputDateAwalString = data.tanggalAwal.toString();
              final inputDateAwalFormat = DateFormat('yyyy-MM-dd');
              final outputDateAwalFormat = DateFormat('d/M/y');
              final inputDateAwal = inputDateAwalFormat.parse(inputDateAwalString);
              final outputDateAwalString = outputDateAwalFormat.format(inputDateAwal);
              tglAwalController.text = outputDateAwalString;

              final dynamic inputDateAkhirString = data.tanggalAkhir.toString();
              final inputDateAkhirFormat = DateFormat('yyyy-MM-dd');
              final outputDateAkhirFormat = DateFormat('d/M/y');
              final inputDateAkhir = inputDateAkhirFormat.parse(inputDateAkhirString);
              final outputDateAkhirString = outputDateAkhirFormat.format(inputDateAkhir);
              tglAkhirController.text = outputDateAkhirString;

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
                      'Detail Log Cuti Tahunan',
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
                                  controller: tglAwalController,
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
                                  controller: tglAkhirController,
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
                  ],
                ),
              );
            }
          },
        ));
  }
}
