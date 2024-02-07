import 'package:get/get.dart';
import 'package:project/src/core/enums/duration_enum.dart';
import 'package:project/src/core/enums/duration_karyawan_enum.dart';
import 'package:project/src/core/model/user_me_model.dart';
import 'package:project/src/core/services/appbar/appbar_service.dart';
import 'package:project/src/core/services/dashboard/dashboard_hr/dashboard_saya_services.dart';

class DashboardSayaController extends GetxController {
  DashboardSayaService service;
  AppbarService appbarservice;
  DashboardSayaController(this.service, this.appbarservice);

  Future<UserMeModel?> getUser() async {
    return await appbarservice.fetchUserMe();
  }

  Future<int?> getSisaCutiTahunan({required KaryawanDuration duration}) async {
    final response = await service.getSisaCutiTahunan();
    return response.data;
  }

  Future<int?> getIzin3Jam({required KaryawanDuration duration}) async {
    if (duration == HRDuration.yearly) {
      final response =
          await service.getlIzin3Jam(duration: KaryawanDuration.yearly);
      return response.data;
    } else {
      final response =
          await service.getlIzin3Jam(duration: KaryawanDuration.monthly);
      return response.data;
    }
  }

  Future<int?> getCutiTahunan({required KaryawanDuration duration}) async {
    final response =
        await service.getCutiTahunan(duration: KaryawanDuration.yearly);
    return response;
  }

  Future<int?> getCutiKhusus({required KaryawanDuration duration}) async {
    final response =
        await service.getCutiKhusus(duration: KaryawanDuration.yearly);
    return response;
  }

  Future<int?> getIzinSakit({required KaryawanDuration duration}) async {
    final response =
        await service.getIzinSakit(duration: KaryawanDuration.yearly);
    return response;
  }

  Future<int?> getPerjalananDinas({required KaryawanDuration duration}) async {
    final response =
        await service.getPerjalananDinas(duration: KaryawanDuration.yearly);
    return response;
  }
}
