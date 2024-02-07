import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/home/master/master_company/master_company.dart';
import '../../../colors/color.dart';
import '../../../helper/auth_pref_helper.dart';

int idPerusahaan = 0;

class MasterCompanyService {
  final url = 'http://192.168.2.155:8000/perusahaan/input';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future inputPerusahaan(String namaPerusahaan, context) async {
    try {
      final tokenRespons = '';
      final tokenJson = jsonDecode(tokenRespons);
      final token = tokenJson['access_token'];
      final headerss = {
        "Authorization": 'Bearer $token',
      };
      final response = await dio.post(
        url,
        options: Options(
          headers: headerss,
        ),
        queryParameters: {
          'nama': namaPerusahaan,
        },
      );
      print('RESPONSE : ${response.data}');
      print('RESPONSE : ${response.statusCode}');
      if (response.statusCode == 200) {
        // return response.data.toString();
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 278,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kWhiteColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 31,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          color: kDarkGreenColor,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: kGreenColor,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Data Berhasil di Tambah',
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
                          backgroundColor: kDarkGreenColor,
                          fixedSize: const Size(120, 45),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  MasterCompany(),
                            ),
                          );
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
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 278,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kWhiteColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 31,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          color: kLightRedColor,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: kLightRedColor,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Data Gagal di Tambah',
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
                          backgroundColor: kLightRedColor,
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
        return 'Failed to change password';
      }
    } catch (e) {
      // menangani kesalahan yang terjadi saat melakukan permintaan
      if (e is DioError) {
        if (e.response != null) {
          // jika server memberikan respons, cetak pesan kesalahan dari server
          print(e.response!.data);
        } else {
          // jika tidak ada respons dari server, cetak pesan kesalahan dari Dio
          print(e.message);
        }
      } else {
        // jika kesalahan bukan berasal dari Dio, cetak pesan kesalahan secara umum
        print(e.toString());
      }
    }
  }

  fetchInputPerusahaanModel() {}

  fetchListPerusahaanModel() {}
}



// showDialog(
//                                                       context: context,
//                                                       builder: (context) {
//                                                         return Dialog(
//                                                           shape:
//                                                               RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         8),
//                                                           ),
//                                                           child: Container(
//                                                             width: 400,
//                                                             height: 300,
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           8),
//                                                               color:
//                                                                   Colors.white,
//                                                             ),
//                                                             child: Column(
//                                                               children: [
//                                                                 Container(
//                                                                   width: double
//                                                                       .infinity,
//                                                                   height: 30,
//                                                                   decoration:
//                                                                       const BoxDecoration(
//                                                                           color: Color(
//                                                                               0xff05DAA7),
//                                                                           borderRadius:
//                                                                               BorderRadius.vertical(
//                                                                             top:
//                                                                                 Radius.circular(8),
//                                                                           )),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   height: 16,
//                                                                 ),
//                                                                 const Icon(
//                                                                   Icons
//                                                                       .check_circle,
//                                                                   color: Color(
//                                                                       0xff05DAA7),
//                                                                   size: 120,
//                                                                 ),
//                                                                 const Text(
//                                                                   'Data Berhasil di Tambah',
//                                                                   textAlign:
//                                                                       TextAlign
//                                                                           .center,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w500,
//                                                                     fontSize:
//                                                                         18,
//                                                                   ),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   height: 24,
//                                                                 ),
//                                                                 ElevatedButton(
//                                                                   style: ElevatedButton
//                                                                       .styleFrom(
//                                                                     shape:
//                                                                         RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               8),
//                                                                     ),
//                                                                     backgroundColor:
//                                                                         const Color(
//                                                                             0xff05DAA7),
//                                                                     fixedSize:
//                                                                         const Size(
//                                                                             120,
//                                                                             43),
//                                                                   ),
//                                                                   onPressed:
//                                                                       () {
//                                                                     Navigator
//                                                                         .push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                           builder: (context) =>
//                                                                               const MasterCompany()),
//                                                                     );
//                                                                   },
//                                                                   child:
//                                                                       const Text(
//                                                                     'Oke',
//                                                                     style:
//                                                                         TextStyle(
//                                                                       fontSize:
//                                                                           20,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                     ),
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );