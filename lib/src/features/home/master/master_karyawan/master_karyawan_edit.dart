// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/src/core/model/master/company/mastercompanylist_model.dart';
import 'package:project/src/core/model/master/karyawan/masterkaryawandetail_model.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanylist_service.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandetail_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanedit_controller.dart';

import '../../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/services/dio_clients.dart';
// import '../../../../core/services/master/master_company/master_company_list.dart';
import '../../../appbar/custom_appbar_widget.dart';
import 'master_karyawan.dart';

class EditMasterKaryawan extends StatefulWidget {
  final int id;
  const EditMasterKaryawan({super.key, required this.id});

  @override
  State<EditMasterKaryawan> createState() => _EditMasterKaryawanState();
}

class _EditMasterKaryawanState extends State<EditMasterKaryawan> {
  final TextEditingController namaPerusahaanController =
      TextEditingController();
  final TextEditingController namaKaryawanController = TextEditingController();
  final selectedPerusahaanController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordkaryawan = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController level = TextEditingController();
  final TextEditingController posisiController = TextEditingController();
  final TextEditingController tanggalBergabungController =
      TextEditingController();
  Map<String, dynamic> dataMasterKaryawan = {};

  String? choseperusahaan;
  // String? _selectedPerusahaan;
  String tanggalAPILahir = '';
  List<Map<String, dynamic>> levelList = [];
  int? selectedId;
  bool isPassword = true;

  final formKey = GlobalKey<FormState>();

  final masterKaryawanDetailcontroller =
      Get.find<MasterKaryawanDetailController>();
  final masterKaryawanEditController = Get.find<MasterKaryawanEditController>();

  late Future<MasterKaryawanDetailModel> _fetchMasterKaryawanDetail;
  
  

  @override
  void initState() {
    super.initState();
    _fetchMasterKaryawanDetail =
        masterKaryawanDetailcontroller.execute(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
        future: _fetchMasterKaryawanDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            MasterKaryawanDetailModel? dataMasterKaryawan = snapshot.data;
            namaKaryawanController.text = snapshot.data?.namaKaryawan ?? '';
            noHpController.text = snapshot.data?.noHp ?? '';
            tempatLahirController.text = snapshot.data?.tempatLahir ?? '';
            alamatController.text = snapshot.data?.alamat ?? '';
            emailController.text = snapshot.data?.email ?? '';
            posisiController.text = snapshot.data?.posisi ?? '';
            level.text = snapshot.data?.level ?? '';
            tanggalLahirController.text = DateFormat('yyyy-MM-dd')
                .format(snapshot.data?.tanggalLahir ?? DateTime.now());
            namaPerusahaanController.text = snapshot.data?.namaPerusahaan ?? '';
            // passwordkaryawan
            selectedId = snapshot.data?.idPerusahaan ?? 0;
            return Form(
                key: formKey,
                child: ListView(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    children: [
                      const Text(
                        'Edit Karyawan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: TextFormField(
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
                              height: 15,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Nama Perusahaan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: kBlackColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TypeAheadFormField<
                                        MasterCompanyListModel>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: namaPerusahaanController,
                                        decoration: InputDecoration(
                                          hintText: 'Pilih Perusahaan',
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
                                        final MasterCompanyListService service =
                                            MasterCompanyListService(
                                                DioClients());
                                        final List<MasterCompanyListModel>
                                            suggestions = await service
                                                .fetchListPerusahaanModel(
                                          filterNama: pattern,
                                        );
                                        return suggestions;
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title:
                                              Text(suggestion.namaPerusahaan),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        selectedId = suggestion.id;
                                        namaPerusahaanController.text =
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
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Tempat Lahir',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: kBlackColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 35,
                                          child: TextFormField(
                                            controller: tempatLahirController,
                                            decoration: InputDecoration(
                                              disabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: kBlackColor,
                                                width: 1,
                                              )),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
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
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Tanggal Lahir',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 35,
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
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Alamat',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: kBlackColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 35,
                                                      child: TextFormField(
                                                        controller:
                                                            alamatController,
                                                        decoration:
                                                            InputDecoration(
                                                          disabledBorder:
                                                              const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                            color: kBlackColor,
                                                            width: 1,
                                                          )),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 10, 0, 5),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            borderSide:
                                                                const BorderSide(
                                                              width: 1,
                                                              color:
                                                                  kBlackColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            'No HP',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14,
                                                              color:
                                                                  kBlackColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 35,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  noHpController,
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return 'No Telepon harus diisi';
                                                                } else if (!RegExp(r'^(\+62|089)\d{9,14}$').hasMatch(value)) {
                                                                  return 'No Telepon minimal harus 9 dan maksimal 14 digit';
                                                                }
                                                                return null;
                                                              },
                                                              inputFormatters: <
                                                                  TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .allow(
                                                                  RegExp(
                                                                      r'[0-9+]'),
                                                                ),
                                                                LengthLimitingTextInputFormatter(
                                                                  14,
                                                                ),
                                                              ],
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              decoration:
                                                                  InputDecoration(
                                                                disabledBorder:
                                                                    const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                  color:
                                                                      kBlackColor,
                                                                  width: 1,
                                                                )),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        0,
                                                                        5),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        kBlackColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'Email',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        kBlackColor,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 35,
                                                                  child:
                                                                      TextFormField(
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return "Email tidak boleh kosong";
                                                                      } else if (!value
                                                                          .contains(
                                                                              '@')) {
                                                                        return "Harus menggunakan @";
                                                                      } else if (!value
                                                                          .contains(
                                                                              '.')) {
                                                                        return "Harus menggunakan .";
                                                                      }
                                                                      return null;
                                                                    },
                                                                    controller:
                                                                        emailController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      disabledBorder:
                                                                          const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                        color:
                                                                            kBlackColor,
                                                                        width:
                                                                            1,
                                                                      )),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                      ),
                                                                      contentPadding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              10,
                                                                              0,
                                                                              5),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              kBlackColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      'Level',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            kBlackColor,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          35,
                                                                      child:
                                                                          DropdownButtonFormField(
                                                                        decoration:
                                                                            InputDecoration(
                                                                          contentPadding: const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              10,
                                                                              0,
                                                                              5),
                                                                          hintText:
                                                                              level.text,
                                                                          hintStyle:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                kBlackColor,
                                                                          ),
                                                                          focusedBorder:
                                                                              const OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: kBlackColor,
                                                                            ),
                                                                          ),
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                const BorderSide(
                                                                              color: Colors.black,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(6),
                                                                          ),
                                                                        ),
                                                                        value: level
                                                                            .text,
                                                                        items: <
                                                                            String>[
                                                                          'HR',
                                                                          'karyawan',
                                                                        ].map<
                                                                            DropdownMenuItem<
                                                                                String>>((String
                                                                            value) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                value,
                                                                            child:
                                                                                Text(value),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (String?
                                                                                value) {
                                                                          if (value == 'HR' ||
                                                                              value == 'karyawan') {
                                                                            setState(() {
                                                                              level.text = value.toString();
                                                                            });
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Text(
                                                                          'Posisi',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                kBlackColor,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              35,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                posisiController,
                                                                            decoration:
                                                                                InputDecoration(
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
                                                                      ],
                                                                    ),
                                                                     const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Text(
                                                                          'Ubah Password Karyawan',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                kBlackColor,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              35,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                passwordkaryawan,
                                                                                 obscureText: isPassword,
                                                                            decoration:
                                                                                InputDecoration(
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
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
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
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                kRedColor,
                                                                            fixedSize:
                                                                                const Size(
                                                                              90,
                                                                              29,
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
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
                                                                                                Navigator.pushReplacement(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (context) => MasterKaryawan(),
                                                                                                  ),
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
                                                                          child:
                                                                              const Icon(Icons.cancel_outlined),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              24,
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                kGreenColor,
                                                                            fixedSize:
                                                                                const Size(
                                                                              90,
                                                                              29,
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            // if (formKey.currentState!.validate()) {
                                                                            //   if (selectedId != null) {

                                                                            //     Get.toNamed('/master-karyawan');
                                                                            //   }
                                                                            // }
                                                                            await masterKaryawanEditController.masterKaryawanEdit(
                                                                                id: widget.id,
                                                                                perusahaanId: selectedId!,
                                                                                namakaryawan: namaKaryawanController.text,
                                                                                alamat: alamatController.text,
                                                                                email: emailController.text,
                                                                                level: level.text,
                                                                                nohp: noHpController.text,
                                                                                posisi: posisiController.text,
                                                                                tanggallahir: tanggalLahirController.text,
                                                                                tempatlahir: tempatLahirController.text,
                                                                                password: passwordkaryawan.text,
                                                                                newPassword: newPasswordController.text,);
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
                                                                                          'Data Karyawan Telah berhasil di ubah',
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
                                                                                            Navigator.pushReplacement(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                builder: (context) => MasterKaryawan(),
                                                                                              ),
                                                                                            );
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
                                                                          child:
                                                                              const Icon(Icons.save),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ])
                                                        ])
                                                  ])
                                            ])
                                      ])
                                ])
                          ])
                    ]));
          }
        },
      ),
    );
  }
}
