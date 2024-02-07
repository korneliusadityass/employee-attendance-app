import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/confirm_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/delete_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/detail_cuti_tahunan_hr_controller.dart';
import 'package:project/src/features/detail/detail_pengajuan_hr/detail_cuti_tahunan/widget/input_attachment_cuti_tahunan_controller.dart';
import 'package:project/util/navhr.dart';

import '../../../../core/colors/color.dart';
import '../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/detail_cuti_tahunan_model_hr.dart';
import '../../../appbar/custom_appbar_widget.dart';

class DetailCutiTahunanHR extends StatefulWidget {
  const DetailCutiTahunanHR({super.key});

  @override
  State<DetailCutiTahunanHR> createState() => _DetailCutiTahunanHRState();
}

class _DetailCutiTahunanHRState extends State<DetailCutiTahunanHR> {
  final TextEditingController tglAwalformController = TextEditingController();

  final TextEditingController tglAkhirformController = TextEditingController();

  final TextEditingController jumlahHariController = TextEditingController();
  final TextEditingController judulCutiController = TextEditingController();
  final TextEditingController namakaryawanController = TextEditingController();

  final args = Get.arguments;
  final confirmCutiTahunanController =
      Get.find<ConfirmCutiTahunanHrController>();
  final deleteCutiTahunanController = Get.find<DeleteCutiTahunanHrController>();
  final controller = Get.find<DetailCutiTahunanHrController>();
  final inputAttachmentCutiTahunanController =
      Get.find<InputAttachmentCutiTahunanHrController>();

  var selectedItem = '';

  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round() + 1;

    return durasi;
  }

  FilePickerResult? result;
  List<File>? _filename;
  int maxFile = 5;
  int maxFilesSize = 10485760;
  String? errorMessage;
  bool isLoading = false;
  void pickFile() async {
    try {
      isLoading = true;
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'pdf', 'jpg '],
        allowMultiple: true,
      );
      if (result != null) {
        List<PlatformFile>? platformFiles = result!.files;
        List<File> newFiles = [];
        bool hasInvalidFile = false;
        for (PlatformFile platformFile in platformFiles) {
          if (platformFile.size <= maxFilesSize) {
            File newFile = File(platformFile.path!);
            newFiles.add(newFile);
          } else {
            debugPrint('File yang diperbolehkan hanya 10mb!!');
            hasInvalidFile = true;
          }
        }
        if (hasInvalidFile) {
          errorMessage = 'File yang diperbolehkan hanya 10mb!!';
        } else if ((_filename?.length ?? 0) + newFiles.length <= maxFile) {
          _filename ??= [];
          _filename!.addAll(newFiles);
          debugPrint('Selected files: $_filename');

          errorMessage = null;
        } else {
          debugPrint('File telah mencapai batas!');

          errorMessage = 'File telah mencapai batas!';

          int maxNewFiles = maxFile - (_filename?.length ?? 0);
          if (maxNewFiles > 0) {
            _filename ??= [];
            _filename!.addAll(newFiles.take(maxNewFiles));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: controller.execute(args),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              print('Wait');
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print('error');
              return const Text('error fetch data');
            } else {
              print('berhasil');
              DetailPengajuanCutiTahunanHrModel? data = snapshot.data;
              namakaryawanController.text = data!.namaKaryawan;
              judulCutiController.text = data.judul;
              jumlahHariController.text = data.jumlahHari.toString();
              tglAwalformController.text =
                  data.tanggalAwal.toString().substring(0, 10);
              tglAkhirformController.text =
                  data.tanggalAkhir.toString().substring(0, 10);
              return Scaffold(
                appBar: CustomAppBarWidget(),
                drawer: const NavHr(),
                body: ListView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                    bottom: 50,
                  ),
                  children: [
                    const Text(
                      'Detail Cuti Tahunan Hr',
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
                        // keyboardType: TextInputType.text,
                        controller: namakaryawanController,
                        decoration: InputDecoration(
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
                    10.height,
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Judul Cuti Tahunan',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    5.height,
                    SizedBox(
                      width: 270,
                      height: 35,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: judulCutiController,
                        decoration: InputDecoration(
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
                    5.height,
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    // height: 55,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Text(
                                        'Tanggal Awal',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            20.width,
                            SizedBox(
                              width: 120,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    // height: 55,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Text(
                                        'Tanggal Akhir',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            20.width,
                            SizedBox(
                              width: 30,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    // height: 55,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Text(
                                        'Hari',
                                        style: TextStyle(
                                          fontSize: 14,
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
                    10.height,
                    StatefulBuilder(
                      builder: (context, setStatet) => Row(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 35,
                            child: TextFormField(
                              enabled: false,
                              controller: tglAwalformController,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBlackColor,
                                    width: 1,
                                  ),
                                ),
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
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 110,
                            height: 35,
                            child: TextFormField(
                              enabled: false,
                              controller: tglAkhirformController,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBlackColor,
                                    width: 1,
                                  ),
                                ),
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
                              onTap: () {},
                            ),
                          ),
                          20.width,
                          SizedBox(
                            width: 50,
                            height: 35,
                            child: TextFormField(
                              enabled: false,
                              // textAlign: TextAlign.center,
                              keyboardType: TextInputType.none,
                              controller: jumlahHariController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBlackColor,
                                    width: 1,
                                  ),
                                ),
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
                                    pickFile();
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
                        if (_filename != null)
                          ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: _filename!
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
                                              setState(() {
                                                _filename!.removeAt(index);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'File telah dihapus'),
                                                  ),
                                                );
                                              });
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
                        children: const [
                          Text(
                            'Draf',
                            style: TextStyle(
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
                                          'Apakah yakin ingin\nmenghapus data ini ?',
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
                                                await deleteCutiTahunanController
                                                    .deleteCutiTahunanPengajuanHr(
                                                        args);
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
                          child: const Icon(Icons.delete),
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
                            if (_filename?.isEmpty ?? true) {
                              print('kosong om');
                              await confirmCutiTahunanController
                                  .confirmCutiTahunanHr(args);
                            } else {
                              print('ada isi');
                              await inputAttachmentCutiTahunanController
                                  .inputAttachmentCutiTahunanHrr(
                                      args, _filename!);
                              await confirmCutiTahunanController
                                  .confirmCutiTahunanHr(args);
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
          }),
    );
  }
}
