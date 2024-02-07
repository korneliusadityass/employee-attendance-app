import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../../model/approval/cuti_tahunan/cuti_tahunan_attachment_model.dart';
import '../../../model/approval/cuti_tahunan/cuti_tahunan_list_model.dart';
import '../../../model/approval/cuti_tahunan/izin_sakit_detail_need_confirm_model.dart';
import '../../dio_clients.dart';

class CutiTahunanApprovalService {
  DioClients dio;
  CutiTahunanApprovalService(this.dio);

  //list data
  Future<List<ApprovalCutiTahunanListModel>> fetchCutiTahunan({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        '/cuti_tahunan/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => ApprovalCutiTahunanListModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //approved
  Future<Either<Failure, bool>> cutiTahunanApproved(int id) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_tahunan/approver/approved',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menerima";
      return Left(ApprovedCutiTahunanFailure(errorMessage));
    }
  }

  //refuse
  Future<Either<Failure, bool>> cutiTahunanRefuse(int id) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_tahunan/approver/refused',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menolak";
      return Left(RefusedCutiTahunanFailure(errorMessage));
    }
  }

  //detail data
  Future<DetailNeedCutiTahunanModel> fetchDataCutiTahunan(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/cuti_tahunan/hr/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DetailNeedCutiTahunanModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //list attachment
  Future getattachmentApprovalCutiTahunan(int id) async {
    try {
      final response = await dio.dio.get(
        '/cuti_tahunan/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<AttachmentNeedConfirmCutiTahunanModel> attachments =
            data.map((attachment) => AttachmentNeedConfirmCutiTahunanModel.fromJson(attachment)).toList();
        return attachments;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
