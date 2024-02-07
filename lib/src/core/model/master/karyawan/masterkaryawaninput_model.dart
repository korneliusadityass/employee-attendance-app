// To parse this JSON data, do
//
//     final masterKaryawanInputModel = masterKaryawanInputModelFromJson(jsonString);


import 'dart:convert';

class MasterKaryawanInputModel {
    MasterKaryawanInputModel({
        required this.namaKaryawan,
        required this.perusahaanId,
        required this.tempatLahir,
        required this.tanggalLahir,
        required this.alamat,
        required this.noHp,
        required this.email,
        required this.password,
        required this.level,
        required this.posisi,
        required this.tanggalBergabung,
        required this.status,
    });

    final String namaKaryawan;
    final int perusahaanId;
    final String tempatLahir;
    final DateTime tanggalLahir;
    final String alamat;
    final String noHp;
    final String email;
    final String password;
    final String level;
    final String posisi;
    final DateTime tanggalBergabung;
    final String status;

    factory MasterKaryawanInputModel.fromRawJson(String str) => MasterKaryawanInputModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterKaryawanInputModel.fromJson(Map<String, dynamic> json) => MasterKaryawanInputModel(
        namaKaryawan: json["nama_karyawan"],
        perusahaanId: json["perusahaan_id"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        alamat: json["alamat"],
        noHp: json["no_hp"],
        email: json["email"],
        password: json["password"],
        level: json["level"],
        posisi: json["posisi"],
        tanggalBergabung: DateTime.parse(json["tanggal_bergabung"]),
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
        "password": password,
        "level": level,
        "posisi": posisi,
        "tanggal_bergabung": "${tanggalBergabung.year.toString().padLeft(4, '0')}-${tanggalBergabung.month.toString().padLeft(2, '0')}-${tanggalBergabung.day.toString().padLeft(2, '0')}",
        "status": status,
    };
}
