import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../dio_clients.dart';

class DownloadAttachmentIzinSakit {
  DioClients dio;
  DownloadAttachmentIzinSakit(this.dio);

  Future izinSakitDownload(
      int idFile, String fileName, BuildContext context) async {
    try {
      final downloadDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create(recursive: true);
      }
      final file = File('${downloadDirectory.path}/$fileName');
      final response = await dio.dio.get(
        '/ijin_sakit/get_attachment/$idFile',
        queryParameters: {
          'id_file': idFile,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
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
