import 'dart:convert';

class UserMeModel {
  UserMeModel({
    required this.namaKaryawan,
    required this.email,
    required this.alamat,
    required this.noHp,
    required this.level,
    required this.posisi,
    required this.tanggalBergabung,
    required this.status,
  });

  final String namaKaryawan;
  final String email;
  final String alamat;
  final String noHp;
  final String level;
  final String posisi;
  final DateTime tanggalBergabung;
  final String status;

  factory UserMeModel.fromRawJson(String str) =>
      UserMeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserMeModel.fromJson(Map<String, dynamic> json) => UserMeModel(
        namaKaryawan: json["nama_karyawan"],
        email: json["email"],
        alamat: json["alamat"],
        noHp: json["no_hp"],
        level: json["level"],
        posisi: json["posisi"],
        tanggalBergabung: DateTime.parse(json["tanggal_bergabung"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "nama_karyawan": namaKaryawan,
        "email": email,
        "alamat": alamat,
        "no_hp": noHp,
        "level": level,
        "posisi": posisi,
        "tanggal_bergabung":
            "${tanggalBergabung.year.toString().padLeft(4, '0')}-${tanggalBergabung.month.toString().padLeft(2, '0')}-${tanggalBergabung.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
