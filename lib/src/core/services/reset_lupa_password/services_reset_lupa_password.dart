import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class ResetLupaPasswordService {
  DioClients dio;
  ResetLupaPasswordService(this.dio);

  Future<Either<Failure, String>> getResetLupaPassword(String emailAddress, String token) async {
    try {
      final response = await dio.dio.get(
        'forgot_password',
        queryParameters: {
          'emailAddress': emailAddress,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return const Right('Success');
      } else {
        return Left(LupaPasswordFailure(response.data['detail']));
      }
    } on DioError catch (e) {
      return Left(LupaPasswordFailure(e.response?.data['detail']));
    } catch (e) {
      return Left(LupaPasswordFailure(e.toString()));
    }
  }
}
