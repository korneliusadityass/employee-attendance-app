import 'package:project/src/core/model/master/jumlah_cuti_tahunan/detail_data_master_jumlah_cuti_tahunan_model.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/service_detail_data_master_cuti_tahunan.dart';

class DetailDataMasterCutiTahunan {
  MasterJumlahCutiTahunanDetailDataServices service;
  DetailDataMasterCutiTahunan(this.service);

  Future<MasterCutiTahunanModel> execute(int id) async {
    final result = await service.fetchDetailMasterJumlahCutiTahunan(id);

    return result;
  }
}
