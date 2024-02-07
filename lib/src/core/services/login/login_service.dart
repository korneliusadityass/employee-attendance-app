import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/helper/auth_pref_helper.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/core/services/dio_clients.dart';

class LoginService {
  DioClients dio;
  AuthStorageHelper helper;
  LoginService(this.dio, this.helper);

  Future<Either<Failure, Map<String, dynamic>>> login(
      String username, String password) async {
    try {
      final response = await dio.dio.post(
        'login',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );

      final String tokenFromResponse = response.data['access_token'];
      helper.token = tokenFromResponse;

      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage =
          e.response?.data['detail'] ?? "Email atau password salah";
      return Left(LoginFailure(errorMessage));
    }
  }

  Future<void> logout() async {
    await helper.removeToken();
    //remove until root
    Get.offAllNamed(Routes.home);
  }
}
