import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../colors/color.dart';
import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

class CutiTahunanCancelledServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/cancelled';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future cutiThaunanCancelled(int id, BuildContext context) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final response = await dio.patch(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'id_ijin': id,
      //   },
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('Sukses melakukan cancel pada pengajuan!!!');
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
      //                   'Pengajuan berhasil di cancel',
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
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class CancelledCutiTahunanServices {
  DioClients dio;
  CancelledCutiTahunanServices(this.dio);

  Future<Either<Failure, bool>> cancelCutiTahunan(int id) async {
    try {
      final response =
          await dio.dio.patch('/cuti_tahunan/cancelled', queryParameters: {
        'id_ijin': id,
      });
      print(('services status code: ${response.statusCode}'));
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? " gagal cancel";
      return Left(CancelledCutiTahunanFailure(errorMessage));
    }
  }
}
