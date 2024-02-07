import 'dart:convert';

class PengajuanIzin3JamModel {
  PengajuanIzin3JamModel({
    required this.judul,
    required this.tanggalIjin,
    required this.waktuAwal,
    required this.waktuAkhir,
  });

  final String judul;
  final DateTime tanggalIjin;
  final String waktuAwal;
  final String waktuAkhir;

  factory PengajuanIzin3JamModel.fromRawJson(String str) =>
      PengajuanIzin3JamModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PengajuanIzin3JamModel.fromJson(Map<String, dynamic> json) =>
      PengajuanIzin3JamModel(
        judul: json["judul"],
        tanggalIjin: DateTime.parse(json["tanggal_ijin"]),
        waktuAwal: json["waktu_awal"],
        waktuAkhir: json["waktu_akhir"],
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "tanggal_ijin":
            "${tanggalIjin.year.toString().padLeft(4, '0')}-${tanggalIjin.month.toString().padLeft(2, '0')}-${tanggalIjin.day.toString().padLeft(2, '0')}",
        "waktu_awal": waktuAwal,
        "waktu_akhir": waktuAkhir,
      };
}
