import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/model/laporan/izin_3jam/list_model_ijin3_jam.dart';
import 'package:project/src/core/services/dio_clients.dart';

// class DownloadLaporanIzin3JamService {
//   final url = 'http://192.168.2.155:8000/laporan/ijin_3_jam/export';
//   Dio dio = Dio();
//   final pref = Get.find<AuthStorageHelper>();

//   Future downloadLaporanIzin3Jam(
//     int id,
//     BuildContext context, {
//     String filterStatus = 'All',
//     required String? filterNama,
//     required String? tanggalAwal,
//     required String? tanggalAkhir,
//   }) async {
//     try {
//       final tokenResponse = '';
//       final tokenJson = jsonDecode(tokenResponse);
//       final token = tokenJson['access_token'];
//       final headers = {
//         "Authorization": 'Bearer $token',
//       };

//       final queryparameters = {
//         'id_perusahaan': id,
//         'filter_status': filterStatus,
//         if (filterNama != null) 'filter_nama': filterNama,
//         if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
//         if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
//       };

//       final response = await dio.get(
//         url,
//         options: Options(
//           headers: headers,
//         ),
//         queryParameters: queryparameters,
//       );

//       print('LIST IZIN 3 JAM : ${response.statusCode}');
//       if (response.statusCode == 200) {
//         if (context.mounted) {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Container(
//                   width: 278,
//                   height: 250,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 31,
//                         decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(8),
//                           ),
//                           color: kDarkGreenColor,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       const Icon(
//                         Icons.check_circle,
//                         color: kGreenColor,
//                         size: 80,
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       const Text(
//                         'File Berhasil di Export',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 20,
//                           color: kBlackColor,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 24,
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           backgroundColor: kDarkGreenColor,
//                           fixedSize: const Size(120, 45),
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text(
//                           'Oke',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 20,
//                             color: kWhiteColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//         return response.data;
//       } else {
//         print('failed to fetch data');
//       }
//     } on DioError {
//       if (context.mounted) {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Container(
//                 width: 278,
//                 height: 250,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 31,
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(8),
//                         ),
//                         color: kRedColor,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     const Icon(
//                       Icons.warning_rounded,
//                       color: kRedColor,
//                       size: 80,
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     const Text(
//                       'File Gagal di Export',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 20,
//                         color: kBlackColor,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         backgroundColor: kRedColor,
//                         fixedSize: const Size(120, 45),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         'Oke',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color: kWhiteColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }
//   }
// }

class ExportLaporanIzin3JamService {
  DioClients dio;
  ExportLaporanIzin3JamService(this.dio);

  Future<Either<Failure, List<ListLaporanIzin3JamModel>>> exportLaporanIzin3Jam(
    int id, {
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'id_perusahaan': id,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        'laporan/ijin_3_jam/export',
        queryParameters: queryParameters,
      );
      List result = response.data;

      return right(
        result.map((data) => ListLaporanIzin3JamModel.fromJson(data)).toList(),
      );
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal confirm";
      return Left(ConfirmIzin3JamFailure(errorMessage));
    }
  }
}
