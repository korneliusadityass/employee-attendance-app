import 'dart:convert';

class CutitahunanModel {
  CutitahunanModel({
    required this.id,
    required this.judulCutiTahunan,
    required this.jumlahhariCutiTahunan,
    required this.namaKaryawan,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.status,
  });

  final int id;
  final String judulCutiTahunan;
  final int jumlahhariCutiTahunan;
  final String namaKaryawan;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;
  final String status;

  factory CutitahunanModel.fromRawJson(String str) =>
      CutitahunanModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory CutitahunanModel.fromJson(Map<String, dynamic> json) =>
      CutitahunanModel(
        id: json["id"],
        judulCutiTahunan: json["judul"],
        jumlahhariCutiTahunan: json["jumlah_hari"],
        namaKaryawan: json["nama_karyawan"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judulCutiTahunan,
        "jumlah_hari": jumlahhariCutiTahunan,
        "nama_karyawan": namaKaryawan,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "tanggal_akhir":
            "${tanggalAkhir.year.toString().padLeft(4, '0')}-${tanggalAkhir.month.toString().padLeft(2, '0')}-${tanggalAkhir.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
