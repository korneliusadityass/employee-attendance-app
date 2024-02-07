import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../../model/approval/izin_sakit/izin_sakit_attachment_model.dart';
import '../../../model/approval/izin_sakit/izin_sakit_detail_need_confirm_model.dart';
import '../../../model/approval/izin_sakit/izin_sakit_list_model.dart';
import '../../dio_clients.dart';

class IzinSakitApprovalService {
  DioClients dio;
  IzinSakitApprovalService(this.dio);

  //list data
  Future<List<ApprovalIzinSakitListModel>> fetchIzinSakit({
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
        '/ijin_sakit/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => ApprovalIzinSakitListModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //approved
  Future<Either<Failure, bool>> izinSakitApproved(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_sakit/approver/approved',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menerima";
      return Left(ApprovedIzinSakitFailure(errorMessage));
    }
  }

  //refuse
  Future<Either<Failure, bool>> izinSakitRefuse(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_sakit/approver/refused',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menolak";
      return Left(RefusedIzinSakitFailure(errorMessage));
    }
  }

  //detail data
  Future<DetailNeedIzinSakitModel> fetchDataIzinSakit(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/ijin_sakit/hr/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DetailNeedIzinSakitModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //list attachment
  Future getattachmentApprovalIzinSakit(int id) async {
    try {
      final response = await dio.dio.get(
        '/ijin_sakit/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<AttachmentNeedConfirmIzinSakitModel> attachments =
            data.map((attachment) => AttachmentNeedConfirmIzinSakitModel.fromJson(attachment)).toList();
        return attachments;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
