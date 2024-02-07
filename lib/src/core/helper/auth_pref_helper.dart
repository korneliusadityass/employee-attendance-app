import 'package:get_storage/get_storage.dart';

class AuthStorageHelper {
  GetStorage box;
  AuthStorageHelper(this.box);

  String? get token => box.read('token');
  set token(String? value) => box.write('token', value);

  //remove token
  Future<void> removeToken() async => box.remove('token');
}
