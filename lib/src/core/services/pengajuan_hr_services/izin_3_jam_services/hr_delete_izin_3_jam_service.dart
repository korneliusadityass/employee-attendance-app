import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../colors/color.dart';
import '../../../helper/auth_pref_helper.dart';

class DeleteIzin3JamHRService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/hr/delete';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future deleteIzin3JamHR(int id, BuildContext context) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };
      // final response = await dio.delete(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {'id_ijin': id},
      //   data: {
      //     'id_ijin': id,
      //   },
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('berhasil di hapus');
      //   if (context.mounted) {
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return Dialog(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           child: Container(
      //             width: 278,
      //             height: 270,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(8),
      //               color: Colors.white,
      //             ),
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
      //                   'Pengajuan berhasil di hapus',
      //                   textAlign: TextAlign.center,
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
      //                     Navigator.pop(context);
      //                     Navigator.pushReplacement(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => const HRPengajuanIzin3Jam(),
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
      print('gagal di hapus');
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
                      'Pengajuan gagal di hapus\nsilahkan coba lagi',
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

class HrDeleteIzin3JamService {
  DioClients dio;
  HrDeleteIzin3JamService(this.dio);

  Future<Either<Failure, bool>> deleteIzin3Jam(int id) async {
    try {
      final response = await dio.dio.delete(
        '/ijin_3_jam/hr/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteIzin3JamFailure(errorMessage));
    }
  }
}
