// To parse this JSON data, do
//
//     final masterKaryawanUpdateModel = masterKaryawanUpdateModelFromJson(jsonString);


import 'dart:convert';

class MasterKaryawanUpdateModel {
    MasterKaryawanUpdateModel({
        required this.namaKaryawan,
        required this.perusahaanId,
        required this.tempatLahir,
        required this.tanggalLahir,
        required this.alamat,
        required this.noHp,
        required this.email,
        required this.level,
        required this.posisi,
        required this.status,
    });

    final String namaKaryawan;
    final int perusahaanId;
    final String tempatLahir;
    final DateTime tanggalLahir;
    final String alamat;
    final String noHp;
    final String email;
    final String level;
    final String posisi;
    final String status;

    factory MasterKaryawanUpdateModel.fromRawJson(String str) => MasterKaryawanUpdateModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterKaryawanUpdateModel.fromJson(Map<String, dynamic> json) => MasterKaryawanUpdateModel(
        namaKaryawan: json["nama_karyawan"],
        perusahaanId: json["perusahaan_id"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        alamat: json["alamat"],
        noHp: json["no_hp"],
        email: json["email"],
        level: json["level"],
        posisi: json["posisi"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "nama_karyawan": namaKaryawan,
        "perusahaan_id": perusahaanId,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "alamat": alamat,
        "no_hp": noHp,
        "email": email,
        "level": level,
        "posisi": posisi,
        "status": status,
    };
}
