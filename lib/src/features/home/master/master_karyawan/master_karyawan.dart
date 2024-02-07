import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
// import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanylist_service.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandelete_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawaninput_controller.dart';
import 'package:project/src/features/home/master/master_karyawan/master_karyawan_edit.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/master/karyawan/masterkaryawanlist_model.dart';
import '../../../../core/services/dio_clients.dart';
import '../../../../core/services/master/master_company/mastercompany/mastercompanylist_controller.dart';
import '../../../../core/services/master/master_karyawan/masterkaryawan/masterkaryawanlist_controller.dart';
import '../../../appbar/custom_appbar_widget.dart';

class MasterKaryawan extends GetView<MasterKaryawanListController> {
  MasterKaryawan({super.key});

  TextEditingController tambahkaryawan = TextEditingController();
  TextEditingController namaperusahaan = TextEditingController();
  TextEditingController namakaryawan = TextEditingController();
  TextEditingController tempatlahir = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController nohp = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passwordkaryawan = TextEditingController();
  TextEditingController level = TextEditingController();
  TextEditingController posisi = TextEditingController();
  TextEditingController searchKaryawan = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController tanggalBergabungController =
      TextEditingController();
  String chosevalue = '10';
  String? choselevel;
  String? choseperusahaan;
  bool isPassword = true;
  var selectedItem = '';
  String tanggalAPILahir = '';
  String tanggalAPIBergabung = '';
  final formKey = GlobalKey<FormState>();
  bool isFetchingData = true;
  int page = 1;
  int pageSize = 10;
  String order = '';
  int perusahaanId = 0;
  String? filterNama;
  int? selectedId;

  final masterKaryawanInputController =
      Get.find<MasterKaryawanInputController>();
  final masterKaryawanDeleteController =
      Get.find<MasterKaryawanDeleteController>();

  // final perusahaanListController = Get.put(MasterCompanyListController());

  // AREA TABLE CONTOH
  List<dynamic> dataKaryawan = [];
  // final PerusahaanListService _perusahaanListService = PerusahaanListService();
  final List<dynamic> _perusahaanList = [];
  // String? _selectedPerusahaan;
  final String _selectedPerusahaan = '';
  // final formKey = GlobalKey<FormState>();

  int getPerusahaanId(String perusahaanName) {
    final perusahaan = _perusahaanList
        .firstWhere((item) => item['nama_perusahaan'] == perusahaanName);
    return perusahaan['id'];
  }

  final masterCompanyListController = Get.find<MasterCompanyListController>();

  Future<void> fetchData() async {
    controller.dataKaryawan.value = await controller.execute(
      page: page,
      size: pageSize,
      order: order,
      filterNama: filterNama,
      perusahaanId: perusahaanId,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final coba = masterCompanyListController.dataPerusahaan;
    print('COBA $coba');
    return Scaffold(
        appBar: CustomAppBarWidget(),
        drawer: const NavHr(),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.sync(() => fetchData());
          },
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            children: [
              20.height,
              const Text(
                'Karyawan',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              20.height,
              TextFormField(
                keyboardType: TextInputType.text,
                controller: searchKaryawan,
                onChanged: (value) {
                  filterNama = searchKaryawan.text;
                  fetchData();
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.only(
                    right: 170,
                    left: 7,
                  ),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              8.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xff6D9DF9),
                      fixedSize: const Size(194, 45),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Form(
                              key: formKey,
                              child: Container(
                                width: 400,
                                height: 856,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kWhiteColor,
                                ),
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    16.height,
                                    const Text(
                                      'Tambah Karyawan',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    16.height,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          5.height,
                                          const Text(
                                            'Nama Perusahaan',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                             TypeAheadFormField<dynamic>(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                controller: namaperusahaan,
                                                decoration: InputDecoration(
                                                  hintText: 'Pilih Perusahaan',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 1,
                                                      color: kBlackColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              suggestionsCallback:
                                                  (pattern) async {
                                                final MasterCompanyListService
                                                    service =
                                                    MasterCompanyListService(
                                                        DioClients());
                                                final List<dynamic>
                                                    suggestions = await service
                                                        .fetchListPerusahaanModel(
                                                  filterNama: pattern,
                                                );
                                                return suggestions;
                                              },
                                              itemBuilder: (context,
                                                  dynamic suggestion) {
                                                return ListTile(
                                                  title: Text(suggestion
                                                      .namaPerusahaan),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (dynamic suggestion) {
                                                selectedId = suggestion.id;
                                                namaperusahaan.text =
                                                    suggestion.namaPerusahaan;
                                                debugPrint(
                                                    'ID Perusahaan : $selectedId');
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Masukkan Nama Perusahaan';
                                                }
                                                return null;
                                              },
                                            ),
                                          
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Nama Karyawan',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextFormField(
                                            controller: namakaryawan,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  100)
                                            ],
                                            validator: (value) {
                                              if (value!.length < 3 ||
                                                  value.length > 100) {
                                                return 'minimal 3 karakter - maksimal 100 karakter';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              hintText: '',
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Tempat Lahir',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextFormField(
                                            controller: tempatlahir,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              hintText: '',
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Tanggal Lahir',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      tanggalLahirController,
                                                  onTap: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ).then(
                                                      (value) {
                                                        try {
                                                          var hari =
                                                              DateFormat.d()
                                                                  .format(
                                                                      value!);
                                                          var bulan =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var tahun =
                                                              DateFormat.y()
                                                                  .format(
                                                                      value);
                                                          tanggalLahirController
                                                                  .text =
                                                              '$hari/$bulan/$tahun';
                                                          tanggalAPILahir =
                                                              '$tahun-$bulan-$hari';
                                                        } catch (e) {
                                                          null;
                                                        }
                                                      },
                                                    );
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: '',
                                                    fillColor: Colors.white24,
                                                    filled: true,
                                                    suffixIcon: const Icon(Icons
                                                        .date_range_outlined),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 0, 5),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Alamat',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  100)
                                            ],
                                            validator: (value) {
                                              if (value!.length < 3 ||
                                                  value.length > 1000) {
                                                return 'minimal 3 karakter - maksimal 1000 karakter';
                                              }
                                              return null;
                                            },
                                            controller: alamat,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              hintText: '',
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'No Hp',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: nohp,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'No Telepon harus diisi';
                                              } else if (value.length < 9 ||
                                                  value.length > 14) {
                                                return 'No Telepon minimal harus 9 dan maksimal 14 digit';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9+]'),
                                              ),
                                              LengthLimitingTextInputFormatter(
                                                14,
                                              ),
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              hintText: '',
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Email',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Email tidak boleh kosong";
                                              } else if (!value.contains('@')) {
                                                return "Harus menggunakan @";
                                              } else if (!value.contains('.')) {
                                                return "Harus menggunakan .";
                                              }
                                              return null;
                                            },
                                            controller: email,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              hintText: '',
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Password Karyawan',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          StatefulBuilder(
                                            builder: (context, setState) =>
                                                TextFormField(
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    20)
                                              ],
                                              validator: (value) {
                                                if (value!.length < 8 ||
                                                    value.length > 20) {
                                                  return 'minimal 8 karakter - maksimal 20 karakter';
                                                }
                                                return null;
                                              },
                                              controller: passwordkaryawan,
                                              obscureText: isPassword,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 0, 5),
                                                suffixIcon: IconButton(
                                                  icon: isPassword
                                                      ? const Icon(
                                                          Icons.visibility_off)
                                                      : const Icon(
                                                          Icons.visibility),
                                                  onPressed: () {
                                                    setState(() {
                                                      isPassword = !isPassword;
                                                    });
                                                  },
                                                ),
                                                hintText: '',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      const BorderSide(),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                fillColor: Colors.white,
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Level',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 90,
                                            height: 55,
                                            child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 0, 5),
                                                hintText: 'Level',
                                                hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: kBlackColor,
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                              value: choselevel,
                                              items: <String>[
                                                'HR',
                                                'karyawan',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                choselevel = value ?? '';
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Posisi',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextFormField(
                                            controller: posisi,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              hintText: '',
                                              hintStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: kBlackColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Tanggal Bergabung',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      tanggalBergabungController,
                                                  onTap: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ).then(
                                                      (value) {
                                                        try {
                                                          var hari =
                                                              DateFormat.d()
                                                                  .format(
                                                                      value!);
                                                          var bulan =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var tahun =
                                                              DateFormat.y()
                                                                  .format(
                                                                      value);
                                                          tanggalBergabungController
                                                                  .text =
                                                              '$hari/$bulan/$tahun';
                                                          tanggalAPIBergabung =
                                                              '$tahun-$bulan-$hari';
                                                        } catch (e) {
                                                          null;
                                                        }
                                                      },
                                                    );
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: '',
                                                    fillColor: Colors.white24,
                                                    filled: true,
                                                    suffixIcon: const Icon(Icons
                                                        .date_range_outlined),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 0, 5),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  const Color(0xff6D9DF9),
                                              fixedSize: const Size(120, 43),
                                            ),
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                final result =
                                                    await masterKaryawanInputController
                                                        .masterKaryawanInput(
                                                  selectedId!,
                                                  namakaryawan.text,
                                                  tempatlahir.text,
                                                  tanggalAPILahir,
                                                  alamat.text,
                                                  nohp.text,
                                                  email.text,
                                                  passwordkaryawan.text,
                                                  choselevel!,
                                                  posisi.text,
                                                  tanggalAPIBergabung,
                                                );
                                                await fetchData();
                                                print('INI ID : $result');
                                                await Get.toNamed(
                                                          Routes.masterKaryawan,
                                                          arguments: result);
                                              }
                                            },
                                            child: const Text(
                                              'Save',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
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
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.add),
                        7.width,
                        const Text(
                          'Tambah Karyawan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  SizedBox(
                    width: 90,
                    height: 55,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: 'Show',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kBlackColor,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kBlackColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: kBlackColor,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      value: chosevalue,
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
                         chosevalue = value.toString();
                         chosevalue = value!;
                         pageSize = int.parse(chosevalue);
                         fetchData();
                      },
                    ),
                  ),
                  20.height,
                  Obx(
                    () => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xff12EEB9)),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nama Karyawan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nama Perusahaan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tempat Lahir',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tanggal Lahir',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Alamat',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'No Hp',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Level',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Posisi',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tanggal Bergabung',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Action',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                  ],
                                ),
                              ]
                            : List<DataRow>.generate(
                                controller.dataKaryawan.length, (int index) {
                                int rowIndex =
                                    (page - 1) * pageSize + index + 1;
                                MasterKaryawanListModel data =
                                    controller.dataKaryawan[index];
                                return DataRow(
                                  onLongPress: () async {
                                    await Get.toNamed(Routes.masterKaryawan,
                                        arguments: data.id);
                                  },
                                  cells: [
                                    DataCell(Text(rowIndex.toString())),
                                    DataCell(Text(data.namaKaryawan)),
                                    DataCell(Text(data.namaPerusahaan)),
                                    DataCell(Text(data.tempatLahir)),
                                    DataCell(Text(DateFormat('dd/MM/yyyy')
                                        .format(data.tanggalLahir))),
                                    DataCell(Text(data.alamat)),
                                    DataCell(Text(data.noHp)),
                                    DataCell(Text(data.email)),
                                    DataCell(Text(data.level)),
                                    DataCell(Text(data.posisi)),
                                    DataCell(Text(DateFormat('dd/MM/yyyy')
                                        .format(data.tanggalBergabung))),
                                    DataCell(Text(data.status)),
                                    DataCell(
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(12, 12),
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                            ),
                                            onPressed: () async {
                                              Get.to(() => EditMasterKaryawan(
                                                  id: data.id));
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              color: kLightGrayColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16.33,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(9.33, 12),
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Container(
                                                      width: 278,
                                                      height: 250,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: kWhiteColor,
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
                                                                    .circular(
                                                                        8),
                                                              ),
                                                              color:
                                                                  kYellowColor,
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
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  backgroundColor:
                                                                      kLightGrayColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          110,
                                                                          35.81),
                                                                ),
                                                                onPressed: () {
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
                                                                        15,
                                                                    color:
                                                                        kBlackColor,
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
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  backgroundColor:
                                                                      kYellowColor,
                                                                  fixedSize:
                                                                      const Size(
                                                                          110,
                                                                          35.81),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  await masterKaryawanDeleteController
                                                                      .masterKaryawandelete(
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
                                                                        15,
                                                                    color:
                                                                        kBlackColor,
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
                                            child: const Icon(
                                              Icons.delete,
                                              color: kRedColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() => 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_left),
                        onPressed:
                            page > 1 ? () => onPageChange(page - 1) : null,
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
                                '$page',
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
                        onPressed: controller.dataKaryawan.length >= pageSize
                            ? () => onPageChange(page + 1)
                            : null,
                      ),
                    ],
                  ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
