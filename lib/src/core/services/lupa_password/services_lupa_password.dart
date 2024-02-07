import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class LupaPasswordService {
  DioClients dio;
  LupaPasswordService(this.dio);

  Future<Either<Failure, Map<String, dynamic>>> lupaPassword(
      String emailAddress) async {
    try {
      final response = await dio.dio.post(
        'forgot_password',
        queryParameters: {
          "emailAddress": emailAddress,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail']['msg'] ??
          "Email tidak terdaftar didatabase";
      return Left(LupaPasswordFailure(errorMessage));
    }
  }

  Future<Either<Failure, bool>> resetLupaPassword(
      String token, String newPassword) async {
    try {
      final response = await dio.dio.post(
        'change_forgot_password',
        queryParameters: {
          "token": token,
          "new_password": newPassword,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail']['msg'] ??
          "Email tidak terdaftar didatabase";
      return Left(LupaPasswordFailure(errorMessage));
    }
  }
}

// class LupaPasswordService {
//   DioClients dio;
//   LupaPasswordService(this.dio);

//   Future<Either<Failure, String>> getLupaPassword(
//       String emailAddress, String token) async {
//     try {
//       final response = await dio.dio.get(
//         'forgot_password',
//         queryParameters: {
//           'emailAddress': emailAddress,
//         },
//       );
//       if (response.statusCode == 200) {
//         return const Right('Success');
//       } else {
//         return Left(LupaPasswordFailure(response.data['detail']));
//       }
//     } on DioError catch (e) {
//       return Left(LupaPasswordFailure(e.response?.data['detail']));
//     } catch (e) {
//       return Left(LupaPasswordFailure(e.toString()));
//     }
//   }
// }


// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:project/src/core/error/failure.dart';
// import 'package:project/src/core/services/dio_clients.dart';

// class LupaPasswordService {
//   DioClients dio;
//   LupaPasswordService(this.dio);

//   Future<Either<Failure, String>> getLupaPassword(String emailAddress, String token) async {
//     try {
//       final response = await dio.dio.get(
//         'forgot_password',
//         queryParameters: {
//           'emailAddress': emailAddress,
//         },
//         options: Options(headers: {'Authorization': 'Bearer $token'}),
//       );
//       if (response.statusCode == 200) {
//         return const Right('Success');
//       } else {
//         return Left(LupaPasswordFailure(response.data['detail']));
//       }
//     } on DioError catch (e) {
//       return Left(LupaPasswordFailure(e.response?.data['detail']));
//     } catch (e) {
//       return Left(LupaPasswordFailure(e.toString()));
//     }
//   }
// }
