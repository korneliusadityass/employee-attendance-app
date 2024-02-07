import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../util/navhr.dart';
import '../../../core/colors/color.dart';
import '../../appbar/custom_appbar_widget.dart';

class DetailApproveCutiKhusus extends StatefulWidget {
  const DetailApproveCutiKhusus({super.key});

  @override
  State<DetailApproveCutiKhusus> createState() =>
      _DetailApproveCutiKhususState();
}

class _DetailApproveCutiKhususState extends State<DetailApproveCutiKhusus> {
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final DateFormat formatter = DateFormat("dd/MM/YYYY");
  DateTime? endData;
  DateTime? startDate;
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

    return null; // optional while already return type is null
  }

  FilePickerResult? result;
  bool isLoading = false;
  List<File>? files;
  int maxFiles = 5;
  int maxFileSize = 10485760;
  String? errorMessage;

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

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
          setState(() {
            errorMessage = 'File yang diperbolehkan hanya 10mb';
          });
        } else if ((files?.length ?? 0) + newFiles.length <= maxFiles) {
          files ??= [];
          files!.addAll(newFiles);
          debugPrint('Selected files: $files');
          setState(() {
            errorMessage = null;
          });
        } else {
          debugPrint('File telah mencapai batas');
          setState(() {
            errorMessage = 'File telah mencapai batas';
          });
          // Add only the first 5 files if more than 5 files are selected
          int maxNewFiles = maxFiles - (files?.length ?? 0);
          if (maxNewFiles > 0) {
            files ??= [];
            files!.addAll(newFiles.take(maxNewFiles));
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        children: [
          const Text(
            'Detail Aprrove Cuti Khusus',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Nama Karyawan',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: kBlackColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              hintText: 'Venansius',
              hintStyle: const TextStyle(
                color: kBlackColor,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              hintText: 'Kadal Nikah',
              hintStyle: const TextStyle(
                color: kBlackColor,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                    width: 110,
                    child: TextFormField(
                      keyboardType: TextInputType.none,
                      controller: tanggalAwalController,
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
                              tanggalAwalController.text =
                                  '$hari/$bulan/$tahun';
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
                        contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: const BorderSide(
                            width: 1,
                            color: kBlackColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: const BorderSide(
                            width: 1,
                            color: kLightGreenColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 19,
              ),
              Column(
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
                    width: 110,
                    child: TextFormField(
                      keyboardType: TextInputType.none,
                      controller: tanggalAkhirController,
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
                              tanggalAkhirController.text =
                                  '$hari/$bulan/$tahun';
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
                        contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: const BorderSide(
                            width: 1,
                            color: kBlackColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: const BorderSide(
                            width: 1,
                            color: kLightGreenColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 19,
              ),
              Column(
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
                    width: 93,
                    height: 48,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: const BorderSide(
                            width: 1,
                            color: kBlackColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: const BorderSide(
                            width: 1,
                            color: kLightGreenColor,
                          ),
                        ),
                        hintText: '2',
                        hintStyle: const TextStyle(
                          color: kBlackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 12,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
              if (files != null)
                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: files!
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
                                      files!.removeAt(index);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('File telah dihapus'),
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
            height: 12,
          ),
          const Text('Status'),
          const SizedBox(
            height: 5,
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
                  'Draft',
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
                    101,
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
                            color: kWhiteColor,
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
                                  color: kYellowColor,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: kLightGrayColor,
                                      fixedSize: const Size(100, 35.81),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: kYellowColor,
                                      fixedSize: const Size(100, 35.81),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Container(
                                              width: 278,
                                              height: 250,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: kWhiteColor,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 31,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(8),
                                                      ),
                                                      color: kDarkGreenColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color: kGreenColor,
                                                    size: 80,
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Text(
                                                    'Data Berhasil di Hapus',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20,
                                                      color: kBlackColor,
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
                                                          kDarkGreenColor,
                                                      fixedSize:
                                                          const Size(120, 45),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Oke',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20,
                                                        color: kWhiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
                child: const Icon(Icons.delete),
              ),
              const SizedBox(
                width: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlueColor,
                  fixedSize: const Size(
                    101,
                    29,
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.edit),
              ),
              const SizedBox(
                width: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreenColor,
                  fixedSize: const Size(
                    101,
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
                            color: kWhiteColor,
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
                                  color: kDarkGreenColor,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: kGreenColor,
                                size: 80,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                'Pengajuan telah dikirim\nmenunggu konfirmasi Pimpinan dan HR',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: kBlackColor,
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: kDarkGreenColor,
                                  fixedSize: const Size(120, 45),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Oke',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }
}
