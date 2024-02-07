import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project/src/core/model/master/karyawan/masterkaryawanlist_model.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdelete_controller.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverinput_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanlist_controller.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanlist_service.dart';
import 'package:project/src/features/home/master/master_approver/masterapprover_edit.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/master/approver/masterapproverlist_model.dart';
import '../../../../core/services/dio_clients.dart';
import '../../../../core/services/master/master_approver/masterapprover/masterapproverlist_controller.dart';
import '../../../appbar/custom_appbar_widget.dart';

class MasterApprover extends GetView<MasterApproverListController> {
  MasterApprover({super.key});

  TextEditingController tambahapprover = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController namaapprover = TextEditingController();
  TextEditingController namakaryawan = TextEditingController();
  TextEditingController searchApprover = TextEditingController();

  final List<MasterKaryawanListModel> _dataApprover = [];
  final List<MultiSelectItem<Object?>> _karyawanItems = [];

  // ignore: unused_field
  // final int _selectedIndex = 0;
  String chosevalue = '10';
  // String? choseappr;
  int? selectedApprover;
  String? selectedKaryawan;
  var selectedItem = '';
  bool isPassword = true;
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();
  bool isFetchingData = true;
  int page = 1;
  int pageSize = 10;
  int id = 0;
  // bool selectAll = false;
  String? filterNama;
  // AREA TABLE CONTOH
  List<dynamic> dataApprover = [];
  // String? _selectedKaryawan;
  // final List<dynamic> _karyawanList = [];
  // String? _selectedApprover;
  // final List<dynamic> _approverList = [];
  // final ListingApproverService _ListingApproverService =
  //     ListingApproverService();
  // List<dynamic> approvers = [];

  final masterApproverInputController =
      Get.find<MasterApproverInputController>();
  final masterApproverDeleteController =
      Get.find<MasterApproverDeleteController>();
  RxList<MasterKaryawanListModel> dataKaryawan =
      <MasterKaryawanListModel>[].obs;
  final masterKaryawanListController = Get.find<MasterKaryawanListController>();

  Future<void> fetchData() async {
    controller.dataApprover.value = await controller.execute(
      page: page,
      size: pageSize,
      filterNama: filterNama,
      id: id,
    );
  }

  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final coba = masterKaryawanListController.dataKaryawan;
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
          padding: const EdgeInsets.only(
            top: 10,
            right: 16,
            left: 16,
            bottom: 50,
          ),
          children: [
            const Text(
              'Approval',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: searchApprover,
              onChanged: (value) {
                filterNama = searchApprover.text;
                fetchData();
              },
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.only(
                  right: 170,
                  left: 7,
                ),
                hintText: 'Search',
                hintStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(),
                  borderRadius: BorderRadius.circular(6),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: const Color(0xff6D9DF9),
                    fixedSize: const Size(195, 45),
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
                                    width: 280,
                                    height: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Column(children: [
                                      Expanded(
                                          child: ListView(children: [
                                        Container(
                                          width: double.infinity,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff6D9DF9),
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text(
                                          'Tambah Approval',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                              left: 35,
                                              right: 35,
                                              bottom: 150,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
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
                                                  child: TypeAheadFormField<
                                                      dynamic>(
                                                    textFieldConfiguration:
                                                        TextFieldConfiguration(
                                                      controller: namaapprover,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Pilih Approver',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
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
                                                      final MasterKaryawanListService
                                                          service =
                                                          MasterKaryawanListService(
                                                              DioClients());
                                                      final List<dynamic>
                                                          suggestions =
                                                          await service
                                                              .fetchListKaryawan(
                                                        filterNama: pattern,
                                                      );
                                                      return suggestions;
                                                    },
                                                    itemBuilder: (context,
                                                        dynamic suggestion) {
                                                      return ListTile(
                                                        title: Text(suggestion
                                                            .namaKaryawan),
                                                      );
                                                    },
                                                    onSuggestionSelected:
                                                        (dynamic suggestion) {
                                                      namaapprover.text =
                                                          suggestion
                                                              .namaKaryawan;
                                                      selectedApprover =
                                                          suggestion.id;
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Masukkan Nama Approver';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                      'Nama Karyawan',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      height: 50,
                                                      child: TypeAheadFormField<
                                                          dynamic>(
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              namakaryawan,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Pilih Karyawan',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(10),
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
                                                        suggestionsCallback:
                                                            (pattern) async {
                                                          final MasterKaryawanListService
                                                              service =
                                                              MasterKaryawanListService(
                                                                  DioClients());
                                                          final List<dynamic>
                                                              suggestions =
                                                              await service
                                                                  .fetchListKaryawan(
                                                            filterNama: pattern,
                                                          );
                                                          return suggestions;
                                                        },
                                                        itemBuilder: (context,
                                                            dynamic
                                                                suggestion) {
                                                          return ListTile(
                                                            title: Text(suggestion
                                                                .namaKaryawan),
                                                          );
                                                        },
                                                        onSuggestionSelected:
                                                            (dynamic
                                                                suggestion) {
                                                          namakaryawan.text =
                                                              suggestion
                                                                  .namaKaryawan;
                                                          selectedKaryawan =
                                                              suggestion.id
                                                                  .toString();
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
                                                            const Color(
                                                                0xff6D9DF9),
                                                        fixedSize:
                                                            const Size(120, 43),
                                                      ),
                                                      onPressed: () {
                                                        masterApproverInputController
                                                            .masterApproverInput(
                                                          selectedApprover!,
                                                          selectedKaryawan!,
                                                        );
                                                         fetchData();
                                                      },
                                                      child: const Text(
                                                        'Save',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    // const SizedBox(
                                                    //   height: 12,
                                                    // ),
                                                    // const Text(
                                                    //   'Nama Karyawan',
                                                    //   style: TextStyle(
                                                    //     fontWeight: FontWeight.w400,
                                                    //     fontSize: 16,
                                                    //   ),
                                                    // ),
                                                    // const SizedBox(
                                                    //   height: 5,
                                                    // ),
                                                    // StatefulBuilder(
                                                    //   builder: (context, setState) =>
                                                    //       MultiSelectDialogField(
                                                    //     items: _karyawanItems,
                                                    //     decoration: BoxDecoration(
                                                    //       borderRadius:
                                                    //           BorderRadius.circular(
                                                    //               6),
                                                    //       border: Border.all(
                                                    //           color: kBlackColor),
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
                                                    //     searchIcon:
                                                    //         const Icon(Icons.search),
                                                    //     searchable: true,
                                                    //     closeSearchIcon:
                                                    //         const Icon(Icons.close),
                                                    //     onConfirm: (results) {
                                                    //       List<String> selectedIds =
                                                    //           [];
                                                    //       if (results.contains(
                                                    //           "select_all")) {
                                                    //         selectedIds.addAll(
                                                    //             _dataApprover.map(
                                                    //                 (e) => e.id
                                                    //                     .toString()));
                                                    //       } else {
                                                    //         for (var item
                                                    //             in results) {
                                                    //           selectedIds.add(
                                                    //               item.toString());
                                                    //         }
                                                    //       }
                                                    //       setState(() {});
                                                    //     },
                                                    //     chipDisplay:
                                                    //         MultiSelectChipDisplay(
                                                    //       scroll: true,
                                                    //       onTap: (item) {
                                                    //         setState(
                                                    //           () {
                                                    //             // Remove the selected item from the list
                                                    //             _dataApprover
                                                    //                 .removeWhere(
                                                    //                     (karyawan) =>
                                                    //                         karyawan
                                                    //                             .id ==
                                                    //                         item);
                                                    //           },
                                                    //         );
                                                    //       },
                                                    //       icon: const Icon(
                                                    //           Icons.cancel),
                                                    //       chipColor:
                                                    //           Colors.transparent,
                                                    //       textStyle: const TextStyle(
                                                    //         color: kBlackColor,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                      ]))
                                    ]))));
                      },
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.add),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Tambah Approval',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: kWhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
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
                      // setState(
                      //   () {
                      //     chosevalue = value!;
                      //     pageSize = int.parse(chosevalue!);
                      //     fetchData();
                      //   },
                      // );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama Approver',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama Karyawan',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Action',
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
                                ],
                              ),
                            ]
                          : List<DataRow>.generate(
                              controller.dataApprover.length, (int index) {
                              int rowIndex = (page - 1) * pageSize + index + 1;
                              MasterApproverListModel data =
                                  controller.dataApprover[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text(rowIndex.toString())),
                                  DataCell(Text(data.namaApprover)),
                                  DataCell(Text(data.namaKaryawan)),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(12, 12),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: const Color.fromARGB(
                                                0, 123, 123, 123),
                                          ),
                                          onPressed: () async {
                                            Get.to(() => EditMasterApprover(
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
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Container(
                                                    width: 278,
                                                    height: 250,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                                                  .circular(8),
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
                                                            fontWeight:
                                                                FontWeight.w300,
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
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                backgroundColor:
                                                                    kLightGrayColor,
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        35.81),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 20,
                                                                  color:
                                                                      kWhiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 34,
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                backgroundColor:
                                                                    kYellowColor,
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        35.81),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    context);
                                                                await masterApproverDeleteController
                                                                    .masterApproverdelete(
                                                                        data.id);
                                                                await fetchData();
                                                              },
                                                              // fetchData();

                                                              child: const Text(
                                                                'Ya',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 20,
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
                      onPressed: page > 1 ? () => onPageChange(page - 1) : null,
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
                      onPressed: controller.dataApprover.length >= pageSize
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
      ),
    );
  }
}
