import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/controller_master_jumlah_cuti_tahunan.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/generate_controller_master_cuti_tahunan.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/list_master_jumlah_cuti_tahunan_model.dart';
import 'package:project/util/navhr.dart';

import '../../../../core/colors/color.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/master/master_jumlah_cuti_tahunan/master_jumlah_cuti_tahunan.dart';
import '../../../appbar/custom_appbar_widget.dart';

class JumlahCutiTahunan extends StatefulWidget {
  const JumlahCutiTahunan({super.key});

  @override
  State<JumlahCutiTahunan> createState() => _JumlahCutiTahunanState();
}

class _JumlahCutiTahunanState extends State<JumlahCutiTahunan> {
  final TextEditingController tanggalAwalController = TextEditingController();

  final TextEditingController tanggalAkhirController = TextEditingController();

  final TextEditingController tahunController = TextEditingController();

  final TextEditingController jumlahCutiController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

// untuk generate
  final generateController =
      Get.find<MasterJumlahCutiTahunanGenerateController>();
  final controller = Get.find<MasterJumlahCutiTahunanListController>();
  final inputListingCutiTahunan = ListCutiTahunan();

  String? _chosenTampilkan;

  String chosevalue = '20';

  String order = 'asc';

  int page = 1;

  int pageSize = 20;

  int tahun = 0;

  String nama = '';

  bool searchPerusahaan = false;
  String hintText = 'Search nama Karyawan';

  bool isFetchingData = false;

  final int _currentYear = DateTime.now().year;

  final int _minYear = DateTime.now().year;

  Future<void> generate() async {
    int jumlahCuti = int.parse(jumlahCutiController.text);
    int tahun = int.parse(tahunController.text);
    print('ini jumlah cuti :$jumlahCuti');
    final result = await generateController.execute(
      kuota_cuti_tahunan: jumlahCuti,
      tahun: tahun,
    );
    if (result == true) {
      controller.execute();
    }
  }

// void _onChanged(num value) {
  void onPageChange(int newPage) {
    page = newPage;
    fetchData();
  }

  Future fetchData() async {
    controller.execute(
      page: page,
      size: pageSize,
      nama: nama,
      searchPerusahaan: searchPerusahaan, // Ubah ke false sebagai nilai default
    );
  }

  @override
  Widget build(BuildContext context) {
    // List tahun = inputlistcutitahunan.map((e) => e['']).toList();
    // List tahun2023 = tahun.where((element) => element == '').toList();
    // print('TAHUN $tahun2023');
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitFadingFour(
                  size: 20,
                  color: Colors.amber,
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Error fetching data');
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  fetchData;
                },
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  children: [
                    const Text(
                      'Jumlah Cuti Tahunan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (newValue) {
                        setState(() {
                          nama = newValue;
                          fetchData();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: hintText,
                        fillColor: Colors.white24,
                        filled: true,
                        suffixIcon: const Icon(Icons.search),
                        // suffixIcon: const IconButton(
                        //   icon: Icon(Icons.search), onPressed: (){},
                        //   // onPressed: () {
                        //   //   if  {
                        //   //     print('Melakukan pencarian berdasarkan nama perusahaan');
                        //   //   } else(searchPerusahaan){
                        //   //     searchPerusahaan = true;
                        //   //   }
                        //   // },
                        // ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, setState) => CupertinoSwitch(
                        value: searchPerusahaan,
                        onChanged: (newValue) {
                          setState(() {
                            debugPrint(newValue.toString());
                            searchPerusahaan = newValue;
                            fetchData();
                            setState(() {
                              if (searchPerusahaan) {
                                hintText = 'Search nama perusahaan';
                              } else {
                                hintText = 'Search nama karyawan';
                              }
                              fetchData();
                            });
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: GetBuilder<
                                        MasterJumlahCutiTahunanListController>(
                                    builder: (controller) {
                                  return DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 5),
                                      hintText: '20',
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    value: chosevalue,
                                    items: <String>[
                                      '20',
                                      '50',
                                      '100',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      // setState(
                                      //   () {
                                      //     chosevaluedua = value!;
                                      //     pageSize = int.parse(chosevaluedua);
                                      //     fetchData();
                                      //   },
                                      // );
                                      chosevalue = value.toString();
                                      chosevalue = value!;
                                      pageSize = int.parse(chosevalue);
                                      fetchData();
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: kDarkGreenColor,
                                  fixedSize: const Size(170, 50),
                                ),
                                onPressed: () {
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
                                          height: 300,
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
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(8),
                                                  ),
                                                  color: kBlueColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 11,
                                              ),
                                              const Text(
                                                'Generate Data',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    const Text(
                                                      'Tahun',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kBlueColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 1,
                                                    ),
                                                    NumberInputWithIncrementDecrement(
                                                      controller:
                                                          tahunController,
                                                      numberFieldDecoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                          horizontal: 5,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      widgetContainerDecoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          right:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                      incIconDecoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          bottom:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                      incIconSize: 24,
                                                      decIconSize: 24,
                                                      initialValue:
                                                          DateTime.now().year,
                                                      min: DateTime.now().year,
                                                      // onChanged: _onChanged,
                                                    ),
                                                    const SizedBox(
                                                      height: 12.13,
                                                    ),
                                                    const Text(
                                                      'Jumlah Cuti',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kBlueColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 1,
                                                    ),
                                                    NumberInputWithIncrementDecrement(
                                                      controller:
                                                          jumlahCutiController,
                                                      min: 0,
                                                      initialValue: 12,
                                                      numberFieldDecoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                          horizontal: 5,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      widgetContainerDecoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          right:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                      incIconDecoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          bottom:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12.13,
                                              ),
                                              //untuk button berhasil ganerate
                                              ElevatedButton(
                                                onPressed: () {
                                                  generate();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Save'),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  'Generate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => controller.isFetchData.value
                          ? const Text('kosong')
                          : SingleChildScrollView(
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
                                  )),
                                  DataColumn(
                                    label: Text(
                                      'Tanggal Ganerate',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tahun',
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
                                      'Nama Karyawan',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Email',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Posisi/Jabatan',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Jumlah Cuti',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tanggal Bergabung',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Edit Cuti',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                                rows: isFetchingData
                                    ? [
                                        const DataRow(
                                          cells: [
                                            DataCell(
                                                CircularProgressIndicator()),
                                            DataCell(Text('Loading...')),
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
                                        controller.MasterJumlahCutiTahunanList
                                            .value.length,
                                        (int index) {
                                          int rowIndex =
                                              (page - 1) * pageSize + index + 1;
                                          MasterJumlahCutiTahunanModel data =
                                              controller
                                                  .MasterJumlahCutiTahunanList
                                                  .value[index];
                                          return DataRow(cells: [
                                            DataCell(Text(rowIndex.toString())),
                                            DataCell(Text(data.tanggalGenerate
                                                .toString()
                                                .substring(0, 10))),
                                            DataCell(
                                                Text(data.tahun.toString())),
                                            DataCell(Text(data.namaPerusahaan)),
                                            DataCell(Text(data.namaKaryawan)),
                                            DataCell(Text(data.email)),
                                            DataCell(Text(data.posisi)),
                                            DataCell(Text(data.kuotaCutiTahunan
                                                .toString())),
                                            DataCell(Text(data.tanggalBergabung
                                                .toString()
                                                .substring(0, 10))),
                                            DataCell(
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: kLightGrayColor,
                                                ),
                                                onPressed: () async {
                                                  // Navigate to another page with the id obtained from the API
                                                  await Get.toNamed(
                                                    Routes
                                                        .editMasterJumlahCutiTahunan,
                                                    arguments: data.id,
                                                  );
                                                },
                                              ),
                                            ),
                                          ]);
                                        },
                                      ).toList(),
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
                                controller.MasterJumlahCutiTahunanList.length >=
                                        pageSize
                                    ? () => onPageChange(page + 1)
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
