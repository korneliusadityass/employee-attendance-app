import 'package:get/get.dart';
import 'package:project/src/core/enums/duration_enum.dart';
import 'package:project/src/core/model/user_me_model.dart';
import 'package:project/src/core/services/appbar/appbar_service.dart';
import 'package:project/src/core/services/dashboard/dashboard_hr/dashboard_hr_services.dart';

class DashboardHrController extends GetxController {
  DashboardHrService service;
  AppbarService appbarservice;
  DashboardHrController(this.service, this.appbarservice);

  Future<int?> getTotalKaryawanHr() async {
    final response = await service.getTotalKaryawanHr();
    return response.data;
  }

  Future<UserMeModel?> getUser() async {
    return await appbarservice.fetchUserMe();
  }

  Future<int?> getTotalCutiTahunan({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      final response =
          await service.getTotalCutiTahunan(duration: HRDuration.yearly);
      return response.data;
    } else {
      final response =
          await service.getTotalCutiTahunan(duration: HRDuration.monthly);
      return response.data;
    }
  }

  Future<int?> getTotalCutiKhusus({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      final response =
          await service.getTotalCutiKhusus(duration: HRDuration.yearly);
      return response.data;
    } else {
      final response =
          await service.getTotalCutiKhusus(duration: HRDuration.monthly);
      return response.data;
    }
  }

  Future<int?> getTotalIzinSakit({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      final response =
          await service.getTotalIzinSakit(duration: HRDuration.yearly);
      return response.data;
    } else {
      final response =
          await service.getTotalIzinSakit(duration: HRDuration.monthly);
      return response.data;
    }
  }

  Future<int?> getTotalIzin3Jam({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      final response =
          await service.getTotalIzin3Jam(duration: HRDuration.yearly);
      return response.data;
    } else {
      final response =
          await service.getTotalIzin3Jam(duration: HRDuration.monthly);
      return response.data;
    }
  }

  Future<int?> getTotalDinas({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      final response = await service.getTotalDinas(duration: HRDuration.yearly);
      return response.data;
    } else {
      final response =
          await service.getTotalDinas(duration: HRDuration.monthly);
      return response.data;
    }
  }
}
