// To parse this JSON data, do
//
//     final listPerusahaanModel = listPerusahaanModelFromJson(jsonString);

import 'dart:convert';

class ListPerusahaanModel {
  final int id;
  final String namaPerusahaan;

  ListPerusahaanModel({
    required this.id,
    required this.namaPerusahaan,
  });

  factory ListPerusahaanModel.fromRawJson(String str) =>
      ListPerusahaanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListPerusahaanModel.fromJson(Map<String, dynamic> json) =>
      ListPerusahaanModel(
        id: json["id"],
        namaPerusahaan: json["nama_perusahaan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_perusahaan": namaPerusahaan,
      };
}
