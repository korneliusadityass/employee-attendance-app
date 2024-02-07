import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../../error/failure.dart';
import '../../../model/hr_pengajuan_pembatalan/cuti_khusus/hr_list_karyawan_model.dart';
import '../../../model/hr_pengajuan_pembatalan/perjalanan_dinas/hr_perjalanan_dinas_detail_model.dart';
import '../../../model/hr_pengajuan_pembatalan/perjalanan_dinas/hr_perjalanan_dinas_list_model.dart';
import '../../dio_clients.dart';

class HRPerjalananDinasService {
  DioClients dio;
  HRPerjalananDinasService(this.dio);

  Future<List<HrPerjalananDinasListModel>> fetchHrPerjalananDinasList({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        'perjalanan_dinas/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => HrPerjalananDinasListModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //input
  Future<Either<Failure, int>> inputPerjalananDinas(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        'perjalanan_dinas/hr/input',
        queryParameters: {
          'id_karyawan': id,
        },
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal mengirim";
      return Left(HrPerjalananDinasInputFailure(errorMessage));
    }
  }

  //edit
  Future perjalananDinasEdit(int id, String judul, String tanggalAwal, String tanggalAkhir) async {
    try {
      final response = await dio.dio.patch(
        'perjalanan_dinas/hr/update',
        queryParameters: {
          'id_ijin': id,
        },
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      print('EDIT STATUS CODE : ${response.statusCode}');
      if (response.statusCode == 200) {
        print('sukses edit');
      } else {
        throw Exception('gagal ngedit');
      }
    } on DioError catch (e) {
      print(e.response?.data); // response body
      print(e.response?.headers); // response headers
      throw Exception(e.message);
    }
  }

  //cancel
  Future<Either<Failure, bool>> perjalananDinasCancel(int id) async {
    try {
      final response = await dio.dio.patch(
        'perjalanan_dinas/hr/cancelled',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal cancel";
      return Left(HrPerjalananDinasCancelFailure(errorMessage));
    }
  }

  //confirm
  Future<Either<Failure, bool>> perjalananDinasConfirm(int id) async {
    try {
      final response = await dio.dio.patch(
        'perjalanan_dinas/hr/confirm',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal confirm";
      return Left(HrPerjalananDinasConfirmFailure(errorMessage));
    }
  }

  //delete
  Future<Either<Failure, bool>> perjalananDinasdelete(int id) async {
    try {
      final response = await dio.dio.delete(
        'perjalanan_dinas/hr/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(HrPerjalananDinasDeleteFailure(errorMessage));
    }
  }

  //detail
  Future<HrDetailPerjalananDinasModel> fetchDetailHrPerjalananDinas(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        'perjalanan_dinas/hr/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return HrDetailPerjalananDinasModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //delete attachment
  Future<Either<Failure, bool>> perjalananDinasDeleteAttachment(
    int idIjin,
    int idAttachment,
  ) async {
    try {
      final response = await dio.dio.delete(
        'perjalanan_dinas/hr/delete_attachment',
        queryParameters: {
          'id_ijin': idIjin,
          'hapus_id': idAttachment,
        },
      );
      print('STATUS CODE DELETE ATTACH : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(HrPerjalananDinasDeleteFailure(errorMessage));
    }
  }

  Future<List<HrListKaryawanModel>> fetchHrKaryawanList({
    String? filterNama,
  }) async {
    try {
      final queryParameters = {
        if (filterNama != null) 'filter_nama': filterNama,
      };

      final response = await dio.dio.get(
        'user/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => HrListKaryawanModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  Future downloadAttachmentPerjalananDinas(
      int idFile, String fileName, BuildContext context) async {
    try {
      final downloadDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create(recursive: true);
      }
      final file = File('${downloadDirectory.path}/$fileName');

      final response = await dio.dio.get(
        '/perjalanan_dinas/get_attachment/$idFile',
        queryParameters: {
          'id_file': idFile,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      debugPrint('SERVICE STATUS CODE : ${response.statusCode}');
      final downloaded =
          await file.writeAsBytes(response.data, mode: FileMode.write);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    file.runtimeType == Null
                        ? 'Gagal mendapatkan akses penyimpanan'
                        : 'Telah berhasil diunduh ke folder Download',
                  ),
                  if (file.runtimeType != Null)
                    TextButton(
                      onPressed: () async {
                        try {
                          await OpenFilex.open(downloaded.path);
                        } catch (e) {
                          inspect(e);
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Buka'),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
  }
}
