import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project/src/core/services/dio_clients.dart';
import 'package:project/src/features/pengajuan/cuti_tahunan/pengajuan_cuti_tahunan.dart';

import '../../../colors/color.dart';
import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';

class DeleteCutiTahunanService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/delete';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future deleteCutiTahunan(int id, BuildContext context) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {"Authorization": 'Bearer $token'};
      // final response = await dio.delete(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'id_ijin': id,
      //   },
      //   data: {
      //     'id_ijin': id,
      //   },
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('sukses hapus');
      //   if (context.mounted) {
      //     showDialog(
      //         context: context,
      //         builder: (context) {
      //           return Dialog(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(6),
      //             ),
      //             child: Container(
      //               width: 278,
      //               height: 270,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(6),
      //                 color: kWhiteColor,
      //               ),
      //               child: Column(
      //                 children: [
      //                   Container(
      //                     width: double.infinity,
      //                     height: 31,
      //                     decoration: const BoxDecoration(
      //                       borderRadius:
      //                           BorderRadius.vertical(top: Radius.circular(6)),
      //                       color: kDarkGreenColor,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 15,
      //                   ),
      //                   const Icon(
      //                     Icons.check_circle,
      //                     color: kGreenColor,
      //                     size: 80,
      //                   ),
      //                   const SizedBox(
      //                     height: 24,
      //                   ),
      //                   ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(6),
      //                       ),
      //                       backgroundColor: kDarkGreenColor,
      //                       fixedSize: const Size(120, 45),
      //                     ),
      //                     onPressed: () {
      //                       Navigator.pop(context);
      //                       Navigator.pushReplacement(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) =>
      //                               const PengajuanCutiTahunan(),
      //                         ),
      //                       );
      //                     },
      //                     child: const Text(
      //                       'Oke',
      //                       style: TextStyle(
      //                         fontSize: 16,
      //                         fontWeight: FontWeight.w500,
      //                         color: kWhiteColor,
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         });
      //   }
      // }
    } on DioError catch (e) {
      print('data gagall dihapus');
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class DeleteCutiTahunanServices {
  DioClients dio;
  DeleteCutiTahunanServices(this.dio);

  Future<Either<Failure, bool>> deleteCutiTahunan(int id) async {
    try {
      final response = await dio.dio.delete(
        '/cuti_tahunan/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('Services status code: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteCutiTahunanFailure(errorMessage));
    }
  }
}
