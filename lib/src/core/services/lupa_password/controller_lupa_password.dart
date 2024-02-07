// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class LupaPasswordService {
//   final String _baseUrl = 'http://example.com/api/';

//   Future<void> kirimEmailLupaPassword(String email) async {
//     final url = '${_baseUrl}forgot-password';
//     final headers = {'Content-Type': 'application/json'};

//     final body = jsonEncode({'email': email});

//     await http.post(Uri.parse(url), headers: headers, body: body);
//   }

//   Future<void> resetPasswordDenganToken(String token, String password) async {
//     final url = '${_baseUrl}reset-password';
//     final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

//     final body = jsonEncode({'password': password});

//     await http.post(Uri.parse(url), headers: headers, body: body);
//   }
// }

import 'package:get/get.dart';
import 'package:project/src/core/services/lupa_password/services_lupa_password.dart';

class LupaPasswordController extends GetxController {
  LupaPasswordService service;
  LupaPasswordController(this.service);

  Future<void> getLupaPassword(String emailAddress) async {
    final result = await service.lupaPassword(emailAddress);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (success) => Get.snackbar(
          'Success', 'Password reset link has been sent to your email'),
    );
  }

  Future<void> geResetLupaPassword(String token, String newPassword) async {
    final result = await service.resetLupaPassword(token, newPassword);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (success) => Get.snackbar('Success', 'Password berhasil diubah'),
    );
  }
}
