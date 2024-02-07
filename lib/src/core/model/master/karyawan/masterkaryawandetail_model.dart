// To parse this JSON data, do
//
//     final masterKaryawanDetailModel = masterKaryawanDetailModelFromJson(jsonString);

import 'dart:convert';

class MasterKaryawanDetailModel {
  final int id;
  final String namaKaryawan;
  final String namaPerusahaan;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String alamat;
  final String noHp;
  final String email;
  final String level;
  final String posisi;
  final DateTime tanggalBergabung;
  final String status;
  final int idPerusahaan;

  MasterKaryawanDetailModel({
    required this.id,
    required this.idPerusahaan,
    required this.namaKaryawan,
    required this.namaPerusahaan,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.noHp,
    required this.email,
    required this.level,
    required this.posisi,
    required this.tanggalBergabung,
    required this.status,
  });

  factory MasterKaryawanDetailModel.fromRawJson(String str) =>
      MasterKaryawanDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MasterKaryawanDetailModel.fromJson(Map<String, dynamic> json) =>
      MasterKaryawanDetailModel(
        id: json["id"],
        idPerusahaan: json['id_perusahaan'],
        namaKaryawan: json["nama_karyawan"],
        namaPerusahaan: json["nama_perusahaan"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        alamat: json["alamat"],
        noHp: json["no_hp"],
        email: json["email"],
        level: json["level"],
        posisi: json["posisi"],
        tanggalBergabung: DateTime.parse(json["tanggal_bergabung"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_karyawan": namaKaryawan,
        "nama_perusahaan": namaPerusahaan,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "alamat": alamat,
        "no_hp": noHp,
        "email": email,
        "level": level,
        "posisi": posisi,
        "tanggal_bergabung":
            "${tanggalBergabung.year.toString().padLeft(4, '0')}-${tanggalBergabung.month.toString().padLeft(2, '0')}-${tanggalBergabung.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
