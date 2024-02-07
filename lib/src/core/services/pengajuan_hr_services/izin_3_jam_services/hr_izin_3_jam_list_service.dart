import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/izin_3_jam/list_hr_izin_3_jam_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../colors/color.dart';
import '../../../helper/auth_pref_helper.dart';

class Izin3JamListHRService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/hr/list';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future izin3JamListHR(
    BuildContext context, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    required String? tanggalAwal,
    required String? tanggalAkhir,
  }) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final queryparameters = {
      //   'page': page,
      //   'size': size,
      //   'filter_status': filterStatus,
      //   if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
      //   if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      // };

      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: queryparameters,
      // );

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   return response.data;
      // } else {
      //   print('failed to fetch data');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 278,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
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
                      height: 15,
                    ),
                    const Icon(
                      Icons.warning_amber,
                      color: kYellowColor,
                      size: 80,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Gagal mengambil data\nsilahkan coba lagi',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
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
                        backgroundColor: kYellowColor,
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
      }
    }
  }
}

class Izin3JamListHrService {
  DioClients dio;
  Izin3JamListHrService(this.dio);

  Future<List<ListHrIzin3JamModel>> fetchIzin3Jam({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        '/ijin_3_jam/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => ListHrIzin3JamModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
