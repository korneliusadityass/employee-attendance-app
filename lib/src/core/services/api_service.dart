// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:project/src/features/home/dashboard/dashboard.dart';

// import '../../features/home/dashboard/dashboard_karyawan.dart';
// import '../helper/auth_pref_helper.dart';

// class ApiService {
//   final url = 'http://192.168.2.155:8000/login';
//   Future login(String email, String password, context) async {
//     final response = await http.post(Uri.parse(url), body: {
//       'username': email,
//       'password': password,
//     });
//     final pref = Get.find<AuthStorageHelper>();
//     // ignore: unnecessary_string_interpolations
//     debugPrint('${response.body}');
//     debugPrint('${response.statusCode}');
//     if (response.statusCode == 200) {
//       // await AuthStorageHelper().setToken(response.body);
//       final responseData = json.decode(response.body);
//       debugPrint('$responseData');
//       UserMeModel data = await userMe(responseData['access_token']);
//       if (data.level == 'HR') {
//         // Jika pengguna adalah HR
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const Dashboard()));
//       } else {
//         // Jika pengguna adalah karyawan
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const DashboarKaryawan()));
//       }
//     } else {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Container(
//                 width: 400,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 30,
//                       decoration: const BoxDecoration(
//                           color: Color(0xffFF8B8B),
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(8),
//                           )),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     const Icon(
//                       Icons.warning_rounded,
//                       color: Color(0xffFF8B8B),
//                       size: 120,
//                     ),
//                     const Text(
//                       'Email Belum Terdaftar di Master Karyawan!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 18,
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
//                         backgroundColor: const Color(0xffFF8B8B),
//                         fixedSize: const Size(120, 43),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         'Oke',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           });
//     }
//   }
// }

// // Future<UserMeModel> userMe(String token) async {
// //   final dataToken = token;
// //   final result = await Dio().get(
// //     'http://192.168.2.155:8000/user/me',
// //     options: Options(
// //       headers: {'Authorization': 'Bearer $dataToken'},
// //     ),
// //   );

// //   return UserMeModel.fromJson(result.data);
// // }
