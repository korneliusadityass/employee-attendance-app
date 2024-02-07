import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../error/failure.dart';
import '../../../model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_attachment_model.dart';
import '../../../model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_detail_model.dart';
import '../../../model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_list_model.dart';

class PengajuanCutiKhususService {
  DioClients dio;
  PengajuanCutiKhususService(this.dio);

  //list data
  Future<List<CutiKhususListModel>> fetchCutiKhususList({
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
        'cuti_khusus/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => CutiKhususListModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //input
  Future<Either<Failure, int>> inputCutiKhusus(
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        '/cuti_khusus/input',
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
      return Left(CutiKhususInputFailure(errorMessage));
    }
  }

  //delete
  Future<Either<Failure, bool>> cutiKhususdelete(int id) async {
    try {
      final response = await dio.dio.delete(
        '/cuti_khusus/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(CutiKhususDeleteFailure(errorMessage));
    }
  }

  //edit
  Future cutiKhususEdit(
      int id, String judul, String tanggalAwal, String tanggalAkhir) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_khusus/update',
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

  //confirm
  Future<Either<Failure, bool>> cutiKhususConfirm(int id) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_khusus/confirm',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal confirm";
      return Left(CutiKhususConfirmFailure(errorMessage));
    }
  }

  //cancel
  Future<Either<Failure, bool>> cutiKhususCancel(int id) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_khusus/cancelled/',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal cancel";
      return Left(CutiKhususCancelFailure(errorMessage));
    }
  }

  //detail
  Future<DetailCutiKhususModel> fetchDetailCutiKhusus(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/cuti_khusus/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DetailCutiKhususModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //list attachment
  Future cutiKhususGetAttachment(int id) async {
    try {
      final response = await dio.dio.get(
        '/cuti_khusus/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );
      if (response.statusCode == 200) {
        final CutiKhususListAttachmentModel data =
            CutiKhususListAttachmentModel.fromJson(response.data);
        final List<CutiKhususAttachmentModel> attachments = data.data;
        return attachments;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  //input attachment
  Future<Either<Failure, bool>> cutiKhususInputAttachment(
      int id, List<File> files) async {
    try {
      List<MultipartFile> multipartFiles = [];
      for (int i = 0; i < files.length; i++) {
        String fileName = files[i].path.split('/').last;
        multipartFiles.add(
          await MultipartFile.fromFile(files[i].path, filename: fileName),
        );
      }

      FormData formData = FormData.fromMap({
        "id_ijin": id,
        "input_baru": multipartFiles,
      });

      final response = await dio.dio.post(
        '/cuti_khusus/input_attachment',
        queryParameters: {
          'id_ijin': id,
        },
        data: formData,
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(CutiKhususInputAttachmentEditFailure(errorMessage));
    }
  }

  //delete attachment
  Future<Either<Failure, bool>> cutiKhususDeleteAttachment(
    int idIjin,
    int idAttachment,
  ) async {
    try {
      final response = await dio.dio.delete(
        '/cuti_khusus/delete_attachment',
        queryParameters: {
          'id_ijin': idIjin,
          'hapus_id': idAttachment,
        },
      );
      print('STATUS CODE DELETE ATTACH : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(CutiKhususDeleteFailure(errorMessage));
    }
  }

  //download attachment
  Future cutiKhususDownload(
      int idFile, String fileName, BuildContext context) async {
    try {
      final downloadDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create(recursive: true);
      }
      final file = File('${downloadDirectory.path}/$fileName');

      final response = await dio.dio.get(
        '/cuti_khusus/get_attachment/$idFile',
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
