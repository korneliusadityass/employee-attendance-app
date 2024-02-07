import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/master/company/mastercompanydetail_model.dart';

import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

class DetailMasterCompanyService {
  final url = 'http://192.168.2.155:8000/perusahaan/data';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  FutureOr<Map<String, dynamic>> detailMasterCompany(int id) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'id': id,
      //   },
      // );

      // final Map<String, dynamic> responseMap = response.data;

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('Succes!!!');
      //   print(responseMap);
      //   return responseMap;
      // } else {
      //   print('Failed!!!');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('Failed to fetch data');
  }

  // detailMasterKaryawan(int id) {}
}


class MasterCompanyDetailService {
  DioClients dio;
  MasterCompanyDetailService(this.dio);

  Future<MasterCompanyDetailModel> fetchMasterCompanyDetail(int id) async {
    try {
      final queryParameters = {
        'id': id,
      };

      final response = await dio.dio.get(
        '/perusahaan/data',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return MasterCompanyDetailModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}