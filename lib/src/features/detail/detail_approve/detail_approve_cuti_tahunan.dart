import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../util/navhr.dart';
import '../../../core/colors/color.dart';
import '../../appbar/custom_appbar_widget.dart';

class DetailApprovalCutiTahunan extends StatefulWidget {
  const DetailApprovalCutiTahunan({super.key});

  @override
  State<DetailApprovalCutiTahunan> createState() =>
      _DetailApprovalCutiTahunanState();
}

class _DetailApprovalCutiTahunanState extends State<DetailApprovalCutiTahunan> {
  final TextEditingController tglAwalformController = TextEditingController();

  final TextEditingController tglAkhirformController = TextEditingController();

  final TextEditingController hariController = TextEditingController();
  final TextEditingController sisaCutiController = TextEditingController();
  var selectedItem = '';

  @override
  Widget build(BuildContext context) {
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
            'Detail Approval Cuti Tahunan',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      const SizedBox(
                        // height: 55,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            'Sisa Cuti Tahunan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: sisaCutiController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
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
                  width: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Judul Cuti Tahunan',
                style: TextStyle(
                  fontSize: 16,
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
            height: 35,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
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
                const SizedBox(
                  width: 20,
                ),
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
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
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
                    controller: tglAwalformController,
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                      // hintText: 'tanggal awal',
                      fillColor: Colors.white24,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
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
                            tglAwalformController.text =
                                DateFormat.yMd().format(value!);
                          } catch (e) {
                            null;
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 110,
                  height: 35,
                  child: TextFormField(
                    controller: tglAkhirformController,
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                      // hintText: 'tanggal awal',
                      fillColor: Colors.white24,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
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
                            tglAkhirformController.text =
                                DateFormat.yMd().format(value!);
                          } catch (e) {
                            null;
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 50,
                  height: 35,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: hariController,
                    decoration: InputDecoration(
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
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'File Keterangan',
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
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.cloud_upload),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Upload',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'file maksimal 10 mb dan maksimal 5 file',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: kLightGrayColor,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 10),
                            backgroundColor: kGreyColor,
                          ),
                          onPressed: () {},
                          child: const Text(
                            'pilih file',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: const Color(0xff949494),
                                      fixedSize: const Size(100, 35.81),
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: const Color(0xffFFF068),
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
                                                color: Colors.white,
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
                    90,
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
                                  fontSize: 12,
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
