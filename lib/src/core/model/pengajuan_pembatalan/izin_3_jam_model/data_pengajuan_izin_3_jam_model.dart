import 'dart:convert';

class DataPengajuanIzin3JamModel {
  DataPengajuanIzin3JamModel({
    required this.judul,
    required this.namaKaryawan,
    required this.tanggalIjin,
    required this.waktuAwal,
    required this.waktuAkhir,
    required this.status,
  });

  final String judul;
  final String namaKaryawan;
  final DateTime tanggalIjin;
  final String waktuAwal;
  final String waktuAkhir;
  final String status;

  factory DataPengajuanIzin3JamModel.fromRawJson(String str) =>
      DataPengajuanIzin3JamModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataPengajuanIzin3JamModel.fromJson(Map<String, dynamic> json) =>
      DataPengajuanIzin3JamModel(
        judul: json["judul"],
        namaKaryawan: json["nama_karyawan"],
        tanggalIjin: DateTime.parse(json["tanggal_ijin"]),
        waktuAwal: json["waktu_awal"],
        waktuAkhir: json["waktu_akhir"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "nama_karyawan": namaKaryawan,
        "tanggal_ijin":
            "${tanggalIjin.year.toString().padLeft(4, '0')}-${tanggalIjin.month.toString().padLeft(2, '0')}-${tanggalIjin.day.toString().padLeft(2, '0')}",
        "waktu_awal": waktuAwal,
        "waktu_akhir": waktuAkhir,
        "status": status,
      };
}
