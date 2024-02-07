// To parse this JSON data, do
//
//     final perjalananDinasInputModel = perjalananDinasInputModelFromJson(jsonString);

import 'dart:convert';

class PerjalananDinasInputModel {
  PerjalananDinasInputModel({
    required this.judul,
    required this.tanggalAwal,
    required this.tanggalAkhir,
  });

  final String judul;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;

  factory PerjalananDinasInputModel.fromRawJson(String str) =>
      PerjalananDinasInputModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerjalananDinasInputModel.fromJson(Map<String, dynamic> json) =>
      PerjalananDinasInputModel(
        judul: json["judul"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "tanggal_akhir":
            "${tanggalAkhir.year.toString().padLeft(4, '0')}-${tanggalAkhir.month.toString().padLeft(2, '0')}-${tanggalAkhir.day.toString().padLeft(2, '0')}",
      };
}
