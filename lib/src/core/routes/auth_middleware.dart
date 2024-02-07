import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/src/core/routes/routes.dart';

class AuthMiddleware extends GetMiddleware {
  GetStorage box;
  AuthMiddleware(this.box);

  @override
  RouteSettings? redirect(String? route) {
    if (box.read('token') == null || box.read('token') == '') {
      return const RouteSettings(name: Routes.login);
    }

    return null;
  }
}
