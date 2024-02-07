import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../colors/color.dart';
import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

class IzinSakitDeleteAttachmentHRServices {
  final url = '';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future izinSakitDeleteAttachmentHR(
      int id, int attachmentId, BuildContext context) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headerss = {"Authorization": 'Bearer $token'};
      // final response = await dio.delete(
      //   url,
      //   options: Options(
      //     headers: headerss,
      //   ),
      //   queryParameters: {
      //     'id_ijin': id,
      //     'hapus_id': attachmentId,
      //   },
      // );

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('Sukses menghapus file');
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
      //               color: kWhiteColor,
      //             ),
      //             child: Column(
      //               children: [
      //                 Container(
      //                   width: double.infinity,
      //                   height: 31,
      //                   decoration: const BoxDecoration(
      //                     borderRadius: BorderRadius.vertical(
      //                       top: Radius.circular(6),
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
      //                   'Attachment Berhasil dihapus',
      //                   style: TextStyle(
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.w400,
      //                     color: kBlackColor,
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 24,
      //                 ),
      //                 ElevatedButton(
      //                   style: ElevatedButton.styleFrom(
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(6),
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
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.w500,
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
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Container(
                width: 278,
                height: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: kWhiteColor,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 31,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        color: kRedColor,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Icon(
                      Icons.warning_amber,
                      color: kRedColor,
                      size: 80,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Attachment gagal dihapus',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: kRedColor,
                        fixedSize: const Size(120, 45),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Oke',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
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

class DeleteAttachmentIzinSakitHrServicess {
  DioClients dio;
  DeleteAttachmentIzinSakitHrServicess(this.dio);

  Future<Either<Failure, bool>> deleteAttachmentIzinSakittHr(
    int idIzin,
    int idAttachment,
  ) async {
    try {
      final response = await dio.dio.delete(
        '/ijin_sakit/hr/delete_attachment',
        queryParameters: {
          'id_ijin': idIzin,
          'hapus_id': idAttachment,
        },
      );
      print('status code delete attach: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteIzinSakitHrFailure(errorMessage));
    }
  }
}
