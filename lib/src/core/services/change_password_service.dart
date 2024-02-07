import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class ChangePasswordService {
  DioClients dio;
  ChangePasswordService(this.dio);

  Future<Either<Failure, String>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final response = await dio.dio.patch(
        'user/change_password',
        queryParameters: {
          'password_lama': oldPassword,
          'password_baru': newPassword
        },
      );
      if (response.statusCode == 200) {
        return const Right('Success');
      } else {
        return Left(ChangePasswordFailure(response.data['detail']));
      }
    } on DioError catch (e) {
      return Left(ChangePasswordFailure(e.response?.data['detail']));
    } catch (e) {
      return Left(ChangePasswordFailure(e.toString()));
    }
  }
}
