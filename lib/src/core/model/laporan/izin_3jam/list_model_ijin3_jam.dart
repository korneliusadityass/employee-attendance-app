// To parse this JSON data, do
//
//     final listLaporanIzin3JamModel = listLaporanIzin3JamModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ListLaporanIzin3JamModel {
    final int id;
    final String namaKaryawan;
    final String posisi;
    final String judul;
    final DateTime tanggalIjin;
    final String waktuAwal;
    final String waktuAkhir;
    final String status;
    final DateTime combineAwal;
    final DateTime combineAkhir;

    ListLaporanIzin3JamModel({
        required this.id,
        required this.namaKaryawan,
        required this.posisi,
        required this.judul,
        required this.tanggalIjin,
        required this.waktuAwal,
        required this.waktuAkhir,
        required this.status,
        required this.combineAwal,
        required this.combineAkhir,
    });

    factory ListLaporanIzin3JamModel.fromRawJson(String str) => ListLaporanIzin3JamModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ListLaporanIzin3JamModel.fromJson(Map<String, dynamic> json) => ListLaporanIzin3JamModel(
        id: json["id"],
        namaKaryawan: json["nama_karyawan"],
        posisi: json["posisi"],
        judul: json["judul"],
        tanggalIjin: DateTime.parse(json["tanggal_ijin"]),
        waktuAwal: json["waktu_awal"],
        waktuAkhir: json["waktu_akhir"],
        status: json["status"],
        combineAwal: DateTime.parse(json["combine_awal"]),
        combineAkhir: DateTime.parse(json["combine_akhir"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_karyawan": namaKaryawan,
        "posisi": posisi,
        "judul": judul,
        "tanggal_ijin": "${tanggalIjin.year.toString().padLeft(4, '0')}-${tanggalIjin.month.toString().padLeft(2, '0')}-${tanggalIjin.day.toString().padLeft(2, '0')}",
        "waktu_awal": waktuAwal,
        "waktu_akhir": waktuAkhir,
        "status": status,
        "combine_awal": combineAwal.toIso8601String(),
        "combine_akhir": combineAkhir.toIso8601String(),
    };
}
