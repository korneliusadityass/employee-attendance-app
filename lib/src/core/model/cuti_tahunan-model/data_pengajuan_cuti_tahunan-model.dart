import 'dart:convert';

class DataCutiTahunanModel {
  DataCutiTahunanModel({
    required this.judul,
    required this.jumlahHari,
    required this.namaKaryawan,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.status,
  });

  final String judul;
  final String jumlahHari;
  final String namaKaryawan;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;
  final String status;

  factory DataCutiTahunanModel.fromRawJson(String str) =>
      DataCutiTahunanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataCutiTahunanModel.fromJson(Map<String, dynamic> json) =>
      DataCutiTahunanModel(
        judul: json["judul"],
        jumlahHari: json["jumlah_hari"],
        namaKaryawan: json["nama_karyawan"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "jumlah_hari": jumlahHari,
        "nama_karyawan": namaKaryawan,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "tanggal_akhir":
            "${tanggalAkhir.year.toString().padLeft(4, '0')}-${tanggalAkhir.month.toString().padLeft(2, '0')}-${tanggalAkhir.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
