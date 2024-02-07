// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project/src/core/model/master/approver/masterapproverdetail_model.dart';
import 'package:project/src/core/services/dio_clients.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdetail_controller.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproveredit_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanlist_service.dart';
import 'package:project/src/features/home/master/master_approver/master_approver.dart';

import '../../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/master/karyawan/masterkaryawanlist_model.dart';
import '../../../appbar/custom_appbar_widget.dart';

class EditMasterApprover extends StatefulWidget {
  final int id;
  const EditMasterApprover({super.key, required this.id});

  @override
  State<EditMasterApprover> createState() => _EditMasterApproverState();
}

class _EditMasterApproverState extends State<EditMasterApprover> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController namaApproverController = TextEditingController();
  final TextEditingController namaKaryawanController = TextEditingController();

  final masterApproverDetailcontroller = Get.find<MasterApproverDetailController>();
  final masterApproverEditController = Get.find<MasterApproverEditController>();

  late Future<MasterApproverDetailModel> _fetchMasterApproverDetail;

  final MasterKaryawanListService _karyawanListService = MasterKaryawanListService(DioClients());

  List<MasterKaryawanListModel> _dataApprover = [];
  List<MultiSelectItem<Object?>> _karyawanItems = [];
  final List<MasterKaryawanListModel> _dataEdit = []; // Menyimpan data karyawan dari API untuk mode edit
  int? selectedKaryawan;
  int? selectedApprover;
  @override
  void initState() {
    super.initState();
    _fetchMasterApproverDetail = masterApproverDetailcontroller.execute(widget.id);
    _fetchKaryawanList();
  }

  Future<void> _fetchKaryawanList() async {
    try {
      final List<MasterKaryawanListModel> karyawanList = await _karyawanListService.fetchListKaryawan(filterNama: null);
      setState(() {
        _dataApprover = karyawanList;
        _karyawanItems = [
          MultiSelectItem("select_all", "Pilih Semua"),
          ...karyawanList.map((karyawan) => MultiSelectItem(karyawan.id, karyawan.namaKaryawan)).toList(),
        ];
      });
    } catch (error) {
      // Handle error
    }
  }

  int? selectedId;
  // List<dynamic> dataApprover = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
        future: _fetchMasterApproverDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            MasterApproverDetailModel? dataMasterApprover = snapshot.data;
            namaApproverController.text = snapshot.data?.namaApprover ?? '';
            namaKaryawanController.text = snapshot.data?.namaKaryawan ?? '';
            selectedId = snapshot.data?.idApprover ?? 0;
            selectedKaryawan = snapshot.data?.idKaryawan ?? 0;
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
                    'Edit Approval',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Nama Approver',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 50,
                        child: TypeAheadFormField<dynamic>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: namaApproverController,
                            decoration: InputDecoration(
                              hintText: namaApproverController.text,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            final MasterKaryawanListService service = MasterKaryawanListService(DioClients());
                            final List<dynamic> suggestions = await service.fetchListKaryawan(
                              filterNama: pattern,
                            );
                            return suggestions;
                          },
                          itemBuilder: (context, dynamic suggestion) {
                            return ListTile(
                              title: Text(suggestion.namaKaryawan),
                            );
                          },
                          onSuggestionSelected: (dynamic suggestion) {
                            selectedId = suggestion.id;
                            namaApproverController.text = suggestion.namaKaryawan;
                            debugPrint('ID Approver : $selectedId');
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Masukkan Nama Approver';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Nama Karyawan',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 50,
                        child: TypeAheadFormField<dynamic>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: namaKaryawanController,
                            decoration: InputDecoration(
                              hintText: 'Pilih Karyawan',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            final MasterKaryawanListService service = MasterKaryawanListService(DioClients());
                            final List<dynamic> suggestions = await service.fetchListKaryawan(
                              filterNama: pattern,
                            );
                            return suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion.namaKaryawan),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            selectedKaryawan = suggestion.id;
                            namaKaryawanController.text = suggestion.namaKaryawan;
                            debugPrint('ID Karyawan : $selectedKaryawan');
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Masukkan Nama Karyawan';
                            }
                            return null;
                          },
                        ),
                      ),
                      // StatefulBuilder(
                      //   builder: (context, setState) => MultiSelectDialogField(
                      //     items: _karyawanItems,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(6),
                      //       border: Border.all(color: kBlackColor),
                      //     ),
                      //     buttonIcon: const Icon(
                      //       Icons.arrow_drop_down,
                      //       color: Colors.black,
                      //     ),
                      //     buttonText: const Text(
                      //       "Pilih Karyawan",
                      //       style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 16,
                      //       ),
                      //     ),
                      //     searchHint: 'Cari Karyawan',
                      //     searchIcon: const Icon(Icons.search),
                      //     searchable: true,
                      //     closeSearchIcon: const Icon(Icons.close),
                      //     onConfirm: (results) {
                      //       List<String> selectedIds = [];
                      //       if (results.contains("select_all")) {
                      //         selectedIds.addAll(_dataApprover.map((e) => e.id.toString()));
                      //       } else {
                      //         for (var item in results) {
                      //           selectedIds.add(item.toString());
                      //         }
                      //       }
                      //       setState(() {});
                      //     },
                      //     chipDisplay: MultiSelectChipDisplay(
                      //       scroll: true,
                      //       onTap: (item) {
                      //         setState(
                      //           () {
                      //             // Remove the selected item from the list
                      //             _dataApprover.removeWhere((karyawan) => karyawan.id == item);
                      //           },
                      //         );
                      //       },
                      //       icon: const Icon(Icons.cancel),
                      //       chipColor: Colors.transparent,
                      //       textStyle: const TextStyle(
                      //         color: kBlackColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                        onPressed: () async {
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
                                                  builder: (context) => MasterApprover(),
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
                        child: const Icon(Icons.cancel_outlined),
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
                          await masterApproverEditController.masterApproverEdit(
                            id: widget.id,
                            approverid: selectedId!,
                            karyawanid: selectedKaryawan!,
                          );
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
                                        'Edit Approval berhasil',
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
                                              builder: (context) => MasterApprover(),
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
                        child: const Icon(Icons.save),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
