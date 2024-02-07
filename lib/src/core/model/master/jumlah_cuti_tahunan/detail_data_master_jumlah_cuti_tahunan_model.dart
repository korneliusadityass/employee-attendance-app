import 'dart:convert';

class MasterCutiTahunanModel {
  final int id;
  final DateTime tanggalGenerate;
  final int tahun;
  final String namaPerusahaan;
  final String namaKaryawan;
  final String email;
  final String posisi;
  final int kuotaCutiTahunan;
  final DateTime tanggalBergabung;

  MasterCutiTahunanModel({
    required this.id,
    required this.tanggalGenerate,
    required this.tahun,
    required this.namaPerusahaan,
    required this.namaKaryawan,
    required this.email,
    required this.posisi,
    required this.kuotaCutiTahunan,
    required this.tanggalBergabung,
  });

  factory MasterCutiTahunanModel.fromRawJson(String str) =>
      MasterCutiTahunanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MasterCutiTahunanModel.fromJson(Map<String, dynamic> json) =>
      MasterCutiTahunanModel(
        id: json["id"],
        tanggalGenerate: DateTime.parse(json["tanggal_generate"]),
        tahun: json["tahun"],
        namaPerusahaan: json["nama_perusahaan"],
        namaKaryawan: json["nama_karyawan"],
        email: json["email"],
        posisi: json["posisi"],
        kuotaCutiTahunan: json["kuota_cuti_tahunan"],
        tanggalBergabung: DateTime.parse(json["tanggal_bergabung"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal_generate": tanggalGenerate.toIso8601String(),
        "tahun": tahun,
        "nama_perusahaan": namaPerusahaan,
        "nama_karyawan": namaKaryawan,
        "email": email,
        "posisi": posisi,
        "kuota_cuti_tahunan": kuotaCutiTahunan,
        "tanggal_bergabung":
            "${tanggalBergabung.year.toString().padLeft(4, '0')}-${tanggalBergabung.month.toString().padLeft(2, '0')}-${tanggalBergabung.day.toString().padLeft(2, '0')}",
      };
}
