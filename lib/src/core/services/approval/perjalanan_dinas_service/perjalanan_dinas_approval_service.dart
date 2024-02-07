import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../../model/approval/perjalanan_dinas/perjalanan_dinas_attachment_need_confirm_model.dart';
import '../../../model/approval/perjalanan_dinas/perjalanan_dinas_detail_need_confirm_model.dart';
import '../../../model/approval/perjalanan_dinas/perjalanan_dinas_list_model.dart';
import '../../dio_clients.dart';

class PerjalananDinasApprovalService {
  DioClients dio;
  PerjalananDinasApprovalService(this.dio);
  
  //list data
  Future<List<ApprovalPerjalananDinasListModel>> fetchPerjalananDinas({
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
        '/perjalanan_dinas/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => ApprovalPerjalananDinasListModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //approved
  Future<Either<Failure, bool>> perjalananDinasApproved(int id) async {
    try {
      final response = await dio.dio.patch(
        '/perjalanan_dinas/approver/approved',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menerima";
      return Left(ApprovedPerjalananDinasFailure(errorMessage));
    }
  }

  //refuse
  Future<Either<Failure, bool>> perjalananDinasRefuse(int id) async {
    try {
      final response = await dio.dio.patch(
        '/perjalanan_dinas/approver/refused',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menolak";
      return Left(RefusedPerjalananDinasFailure(errorMessage));
    }
  }

  //detail data
  Future<DetailNeedPerjalananDinasModel> fetchDataPerjalananDinas(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/perjalanan_dinas/hr/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DetailNeedPerjalananDinasModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //list attachment
  Future getattachmentApprovalPerjalananDinas(int id) async {
    try {
      final response = await dio.dio.get(
        '/perjalanan_dinas/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<AttachmentNeedConfirmPerjalananDinasModel> attachments = data
            .map((attachment) =>
                AttachmentNeedConfirmPerjalananDinasModel.fromJson(attachment))
            .toList();
        return attachments;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
