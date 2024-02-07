import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/laporan/list_perusahaan_model/list_perusahaan_model.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/features/detail/laporan/laporan_cuti_khusus/widgets/laporan_cuti_khusus_controller.dart';
import 'package:project/src/features/detail/laporan/pilih_perusahaan/perusahaan_controller.dart';

import '../../../../../util/navhr.dart';
import '../../../../core/colors/color.dart';
import '../../../appbar/custom_appbar_widget.dart';

class PerusahaanCutiKhusus extends StatefulWidget {
  const PerusahaanCutiKhusus({super.key});

  @override
  State<PerusahaanCutiKhusus> createState() => _PerusahaanCutiKhususState();
}

class _PerusahaanCutiKhususState extends State<PerusahaanCutiKhusus> {
  final controller = Get.find<PerusahaanController>();
  final TextEditingController searchKaryawanController =
      TextEditingController();
  final laporanCutiKhususController = Get.find<LaporanCutiKhususController>();

  String? filterNama;
  int pageSize = 10;
  int page = 1;
  late Future<List<ListPerusahaanModel>> _fetchListPerusahaan;

  Future fetchData() async {
    controller.listPerusahaan.value = await controller.execute(
      page: page,
      size: pageSize,
      filterNama: filterNama,
    );
  }

  void onPageChange(int newPage) async {
    setState(() {
      page = newPage;
      fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchListPerusahaan = controller.execute(filterNama: filterNama);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(),
      drawer: const NavHr(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Column(
                children: [
                  const Text(
                    'Pilih Perusahaan',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: searchKaryawanController,
                    onFieldSubmitted: (value) {
                      filterNama = searchKaryawanController.text;
                      fetchData();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Perusahaan',
                      suffixIcon: const Icon(
                        Icons.search,
                        color: kBlackColor,
                      ),
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
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ListPerusahaanModel>>(
                future: controller.execute(filterNama: filterNama, page: page),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ListPerusahaanModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        ListPerusahaanModel hasil =
                            controller.listPerusahaan[index];
                        return GestureDetector(
                          onTap: () async {
                            await laporanCutiKhususController.execute(hasil.id);
                            Get.toNamed(
                              Routes.pageLaporanCutiKhusus,
                              arguments: hasil.id,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kBlueColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ListTile(
                                  title: Text(
                                    hasil.namaPerusahaan,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 35, // Fixed height for pagination container
              child: Obx(
                () => Row(
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
                      onPressed: controller.listPerusahaan.length >= pageSize
                          ? () {
                              onPageChange(page + 1);
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
