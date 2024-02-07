import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../colors/color.dart';
import '../../../helper/auth_pref_helper.dart';

class HRIzin3JamService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/hr/input';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future hrIzin3jam(int id, String judul, String tanggalIjin, String waktuAwal,
      String waktuAkhir, BuildContext context) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };
      // final queryparameters = {
      //   'id_karyawan': id,
      // };

      // final response = await dio.post(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: queryparameters,
      //   data: {
      //     'judul': judul,
      //     'tanggal_ijin': tanggalIjin,
      //     'waktu_awal': waktuAwal,
      //     'waktu_akhir': waktuAkhir,
      //   },
      // );
      // if (response.statusCode == 200) {
      //   print(response.statusCode);
      //   print('masok');
      //   print('INI RESPONSE STATUS : ${response.data}');
      //   if (context.mounted) {
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return Dialog(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: Container(
      //             width: 278,
      //             height: 250,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10),
      //                 color: Colors.white),
      //             child: Column(
      //               children: [
      //                 Container(
      //                   width: double.infinity,
      //                   height: 31,
      //                   decoration: const BoxDecoration(
      //                     borderRadius: BorderRadius.vertical(
      //                       top: Radius.circular(8),
      //                     ),
      //                     color: kDarkGreenColor,
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 15,
      //                 ),
      //                 const Icon(
      //                   Icons.check_circle,
      //                   color: kGreenColor,
      //                   size: 80,
      //                 ),
      //                 const SizedBox(
      //                   height: 15,
      //                 ),
      //                 const Text(
      //                   'Data Berhasil Ditambah',
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.w400,
      //                     fontSize: 20,
      //                     color: kBlackColor,
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 24,
      //                 ),
      //                 ElevatedButton(
      //                   style: ElevatedButton.styleFrom(
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(8),
      //                     ),
      //                     backgroundColor: kDarkGreenColor,
      //                     fixedSize: const Size(120, 45),
      //                   ),
      //                   onPressed: () {
      //                     Navigator.pushReplacement(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => HRDetailIzin3Jam(
      //                           id: response.data,
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                   child: const Text(
      //                     'Oke',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 20,
      //                       color: kWhiteColor,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   }
      // }
    } on DioError {
      print('udah ada mas e');
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
                      'Hari ini telah diisi',
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

class HrPengajuanIzin3JamService {
  DioClients dio;
  HrPengajuanIzin3JamService(this.dio);

  Future<Either<Failure, int>> pengajuanIzin3Jam(
    int id,
    String judul,
    String tanggalIjin,
    String waktuAwal,
    String waktuAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        '/ijin_3_jam/hr/input',
        queryParameters: {
          'id_karyawan': id,
        },
        data: {
          'judul': judul,
          'tanggal_ijin': tanggalIjin,
          'waktu_awal': waktuAwal,
          'waktu_akhir': waktuAkhir,
        },
      );
      final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal mengirim";
      return Left(PengajuanIzin3JamFailure(errorMessage));
    }
  }
}
