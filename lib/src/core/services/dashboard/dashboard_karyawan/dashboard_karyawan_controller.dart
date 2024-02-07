import 'package:get/get.dart';
import 'package:project/src/core/enums/duration_karyawan_enum.dart';
import 'package:project/src/core/model/user_me_model.dart';
import 'package:project/src/core/services/appbar/appbar_service.dart';
import 'package:project/src/core/services/dashboard/dashboard_karyawan/dashboard_karyawan_services.dart';

class DashboardKaryawanController extends GetxController {
  DashboardKaryawanService service;
  AppbarService appbarservice;
  DashboardKaryawanController(this.service, this.appbarservice);

  Future<UserMeModel?> getUser() async {
    return await appbarservice.fetchUserMe();
  }

  Future<int?> getSisaCutiTahunanKaryawan(
      {required KaryawanDuration duration}) async {
    final response = await service.getSisaCutiTahunanKaryawan();
    return response.data;
  }

  Future<int?> getIzin3JamKaryawan({required KaryawanDuration duration}) async {
    if (duration == KaryawanDuration.yearly) {
      final response =
          await service.getlIzin3JamKaryawan(duration: KaryawanDuration.yearly);
      return response.data;
    } else {
      final response = await service.getlIzin3JamKaryawan(
          duration: KaryawanDuration.monthly);
      return response.data;
    }
  }

  Future<int?> getCutiTahunanKaryawan(
      {required KaryawanDuration duration}) async {
    final response = await service.getCutiTahunanKaryawanTahun(
        duration: KaryawanDuration.yearly);
    return response;
  }

  Future<int?> getCutiKhususKaryawan(
      {required KaryawanDuration duration}) async {
    final response =
        await service.getCutiKhususKaryawan(duration: KaryawanDuration.yearly);
    return response;
  }

  Future<int?> getIzinSakitKaryawan(
      {required KaryawanDuration duration}) async {
    final response =
        await service.getIzinSakitKaryawan(duration: KaryawanDuration.yearly);
    return response;
  }

  Future<int?> getPerjalananDinasKaryawan(
      {required KaryawanDuration duration}) async {
    final response = await service.getPerjalananDinasKaryawan(
        duration: KaryawanDuration.yearly);
    return response;
  }
}
