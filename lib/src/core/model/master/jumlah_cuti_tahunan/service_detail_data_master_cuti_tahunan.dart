import 'package:dio/dio.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/detail_data_master_jumlah_cuti_tahunan_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class MasterJumlahCutiTahunanDetailDataServices {
  DioClients dio;
  MasterJumlahCutiTahunanDetailDataServices(this.dio);

  Future<MasterCutiTahunanModel> fetchDetailMasterJumlahCutiTahunan(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        'master_cuti_tahunan/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return MasterCutiTahunanModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
