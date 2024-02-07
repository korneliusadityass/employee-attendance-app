import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

// class DeleteIzinSakitServices {
//   final url = 'http://192.168.2.155:8000/ijin_sakit/delete';
//   Dio dio = Dio();
//   final pref = Get.find<AuthStorageHelper>();

//   Future deleteIzinSakit(int id, BuildContext context) async {
//     try {
//       // final tokenResponse = '';
//       // final tokenJson = jsonDecode(tokenResponse);
//       // final token = tokenJson['access_token'];
//       // final headers = {
//       //   "Authorization": 'Bearer $token',
//       // };
//       // final response = await dio.delete(
//       //   url,
//       //   options: Options(
//       //     headers: headers,
//       //   ),
//       //   queryParameters: {'id_ijin': id},
//       //   data: {
//       //     'id_ijin': id,
//       //   },
//       // );
//       // print(response.statusCode);
//       // if (response.statusCode == 200) {
//       //   print('berhasil dihapus');
//       //   if (context.mounted) {
//       //     showDialog(
//       //       context: context,
//       //       builder: (context) {
//       //         return Dialog(
//       //           shape: RoundedRectangleBorder(
//       //             borderRadius: BorderRadius.circular(8),
//       //           ),
//       //           child: Container(
//       //             width: 278,
//       //             height: 270,
//       //             decoration: BoxDecoration(
//       //               borderRadius: BorderRadius.circular(8),
//       //               color: Colors.white,
//       //             ),
//       //             child: Column(
//       //               children: [
//       //                 Container(
//       //                   width: double.infinity,
//       //                   height: 31,
//       //                   decoration: const BoxDecoration(
//       //                     borderRadius: BorderRadius.vertical(
//       //                       top: Radius.circular(8),
//       //                     ),
//       //                     color: kDarkGreenColor,
//       //                   ),
//       //                 ),
//       //                 const SizedBox(
//       //                   height: 15,
//       //                 ),
//       //                 const Icon(
//       //                   Icons.check_circle,
//       //                   color: kGreenColor,
//       //                   size: 80,
//       //                 ),
//       //                 const SizedBox(
//       //                   height: 15,
//       //                 ),
//       //                 const Text(
//       //                   'Pengajuan Berhasil di Hapus',
//       //                   style: TextStyle(
//       //                     fontWeight: FontWeight.w400,
//       //                     fontSize: 16,
//       //                     color: kBlackColor,
//       //                   ),
//       //                 ),
//       //                 const SizedBox(
//       //                   height: 24,
//       //                 ),
//       //                 ElevatedButton(
//       //                   style: ElevatedButton.styleFrom(
//       //                     shape: RoundedRectangleBorder(
//       //                       borderRadius: BorderRadius.circular(8),
//       //                     ),
//       //                     backgroundColor: kDarkGreenColor,
//       //                     fixedSize: const Size(120, 45),
//       //                   ),
//       //                   onPressed: () {
//       //                     Navigator.pop(context);
//       //                     Navigator.pushReplacement(
//       //                       context,
//       //                       MaterialPageRoute(
//       //                         builder: (context) => const PengajuanIzinSakit(),
//       //                       ),
//       //                     );
//       //                   },
//       //                   child: const Text(
//       //                     'Oke',
//       //                     style: TextStyle(
//       //                       fontWeight: FontWeight.w500,
//       //                       fontSize: 20,
//       //                       color: kWhiteColor,
//       //                     ),
//       //                   ),
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //         );
//       //       },
//       //     );
//       //   }
//       // }
//     } on DioError catch (e) {
//       print('data gagal dihapus');
//       print(e.error);
//       print(e.message);
//       print(e.response);
//     }
//   }
// }

class DeleteIzinSakitServices {
  DioClients dio;
  DeleteIzinSakitServices(this.dio);

  Future<Either<Failure, bool>> deleteIzinSakit(int id) async {
    try {
      final response = await dio.dio.delete(
        '/ijin_sakit/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('Service status code: ${response.statusCode}');
      return Right(response.data);
      // if (response.statusCode == 200) {
      //   print('delete success');
      // } else {
      //   throw Exception('gagal load data');
      // }
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteIzinSakitFailure(errorMessage));
      // throw Exception(e.message);
    }
  }
}
