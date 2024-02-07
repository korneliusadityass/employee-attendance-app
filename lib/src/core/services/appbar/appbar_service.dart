import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../model/user_me_model.dart';

class AppbarService {
  DioClients dio;
  AppbarService(this.dio);

  Future<UserMeModel> fetchUserMe() async {
    try {
      final response = await dio.dio.get('user/me');
      if (response.statusCode == 200) {
        return UserMeModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
