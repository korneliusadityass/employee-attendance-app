import 'package:get/get.dart';
import 'package:project/src/core/model/master/karyawan/masterkaryawandetail_model.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandetail_service.dart';

class MasterKaryawanDetailController extends GetxController {
  MasterKaryawanDetailService service;
  MasterKaryawanDetailController(this.service);

  Future<MasterKaryawanDetailModel> execute(int id) async {
    final result = await service.fetchMasterKaryawanDetail(id);

    return result;
  }
}
