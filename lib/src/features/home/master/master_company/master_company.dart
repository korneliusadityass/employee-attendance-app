import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanyinput_controller.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../../core/model/master/company/mastercompanylist_model.dart';
import '../../../../core/services/master/master_company/mastercompany/mastercompanydelete_controller.dart';
import '../../../../core/services/master/master_company/mastercompany/mastercompanylist_controller.dart';
import '../../../appbar/custom_appbar_widget.dart';
import 'master_company_edit.dart';

String nama = '';

class MasterCompany extends GetView<MasterCompanyListController> {
  MasterCompany({super.key});

  TextEditingController namaperusahaan = TextEditingController();
  TextEditingController searchPerusahaan = TextEditingController();

  String chosevalue = '10';
  var selectedItem = '';
  bool isFetchingData = true;
  int page = 1;
  int pageSize = 10;
  String order = '';
  String? filterNama;

  final masterCompanyInputController = Get.find<MasterCompanyInputController>();
  final masterCompanyDeleteController =
      Get.find<MasterCompanyDeleteController>();

  final formkey = GlobalKey<FormState>();

  // AREA TABLE CONTOH
  List<dynamic> dataPerusahaan = [];

  Future<void> fetchData() async {
    controller.dataPerusahaan.value = await controller.execute(
      page: page,
      size: pageSize,
      filterNama: filterNama,
      order: order,
    );
  }

  void onPageChange(int newPage) async {
    page = newPage;
    fetchData();
  }

  // AREA TABLE
  @override
  Widget build(BuildContext context) {
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
                  'Company',
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
                  controller: searchPerusahaan,
                  onChanged: (value) {
                    filterNama = searchPerusahaan.text;
                    fetchData();
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.only(
                      right: 170,
                      left: 7,
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
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
                        fixedSize: const Size(215, 45),
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
                                    key: formkey,
                                    child: Container(
                                        width: 280,
                                        height: 280,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: Column(children: [
                                          Container(
                                            width: double.infinity,
                                            height: 31,
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(8),
                                              ),
                                              color: Color(0xff6D9DF9),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text(
                                            'Tambah Perusahaan',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              bottom: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Nama Perusahaan',
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
                                                        value.length > 100) {
                                                      return 'minimal 3 karakter - maksimal 100 karakter';
                                                    }
                                                    return null;
                                                  },
                                                  controller: namaperusahaan,
                                                  decoration: InputDecoration(
                                                    hintText: '',
                                                    hintStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xff6D9DF9),
                                                    fixedSize:
                                                        const Size(120, 43),
                                                  ),
                                                  onPressed: () async {
                                                    if (formkey.currentState!
                                                        .validate()) {
                                                      final result =
                                                          await masterCompanyInputController
                                                              .masterCompanyInput(
                                                        namaperusahaan.text,
                                                      );
                                                      await fetchData();
                                                      print('INI ID : $result');
                                                      // await Get.toNamed(
                                                      //     Routes.masterCompany,
                                                      //     arguments: result);
                                                    }
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
                                              ],
                                            ),
                                          ),
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
                            'Tambah Perusahaan',
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
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nama Perusahaan',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Action',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
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
                                    ],
                                  ),
                                ]
                              : List<DataRow>.generate(
                                  controller.dataPerusahaan.length,
                                  (int index) {
                                  int rowIndex =
                                      (page - 1) * pageSize + index + 1;
                                  MasterCompanyListModel data =
                                      controller.dataPerusahaan[index];

                                  return DataRow(
                                    onLongPress: () async {
                                      // Navigate to another page with the id obtained from the API
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => EditMasterCompany(
                                      //       id: data.id,
                                      //     ),
                                      //   ),
                                      // );
                                      await Get.toNamed(Routes.masterCompany,
                                          arguments: data.id);
                                    },
                                    cells: [
                                      DataCell(Text(rowIndex.toString())),
                                      DataCell(Text(data.namaPerusahaan)),
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
                                                Get.to(() => EditMasterCompany(
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
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Container(
                                                        width: 278,
                                                        height: 250,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: kWhiteColor,
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
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    backgroundColor:
                                                                        kLightGrayColor,
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
                                                                          20,
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
                                                                    await masterCompanyDeleteController
                                                                        .masterCompanydelete(
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
                    Obx(
                      () => Row(
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
                            onPressed:
                                controller.dataPerusahaan.length >= pageSize
                                    ? () => onPageChange(page + 1)
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
        ));
  }
}
