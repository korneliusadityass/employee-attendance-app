// To parse this JSON data, do
//
//     final listLaporanCutiTahunanModel = listLaporanCutiTahunanModelFromJson(jsonString);

import 'dart:convert';

class ListLaporanCutiTahunanModel {
  final int id;
  final String namaKaryawan;
  final String posisi;
  final String judul;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;
  final int jumlahHari;
  final int sisaKuota;
  final String status;

  ListLaporanCutiTahunanModel({
    required this.id,
    required this.namaKaryawan,
    required this.posisi,
    required this.judul,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.jumlahHari,
    required this.sisaKuota,
    required this.status,
  });

  factory ListLaporanCutiTahunanModel.fromRawJson(String str) =>
      ListLaporanCutiTahunanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListLaporanCutiTahunanModel.fromJson(Map<String, dynamic> json) =>
      ListLaporanCutiTahunanModel(
        id: json["id"],
        namaKaryawan: json["nama_karyawan"],
        posisi: json["posisi"],
        judul: json["judul"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
        jumlahHari: json["jumlah_hari"],
        sisaKuota: json["sisa_kuota"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_karyawan": namaKaryawan,
        "posisi": posisi,
        "judul": judul,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "tanggal_akhir":
            "${tanggalAkhir.year.toString().padLeft(4, '0')}-${tanggalAkhir.month.toString().padLeft(2, '0')}-${tanggalAkhir.day.toString().padLeft(2, '0')}",
        "jumlah_hari": jumlahHari,
        "sisa_kuota": sisaKuota,
        "status": status,
      };
}
