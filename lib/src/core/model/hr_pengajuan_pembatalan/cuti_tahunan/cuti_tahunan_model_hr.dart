// To parse this JSON data, do
//
//     final cutiTahunanHrModel = cutiTahunanHrModelFromJson(jsonString);

import 'dart:convert';

class CutiTahunanHrModel {
  final int id;
  final int masterCutiTahunanId;
  final int kuotaCutiTahunan;
  final String namaKaryawan;
  final String judul;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;
  final int jumlahHari;
  final String status;

  CutiTahunanHrModel({
    required this.id,
    required this.masterCutiTahunanId,
    required this.kuotaCutiTahunan,
    required this.namaKaryawan,
    required this.judul,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.jumlahHari,
    required this.status,
  });

  factory CutiTahunanHrModel.fromRawJson(String str) =>
      CutiTahunanHrModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CutiTahunanHrModel.fromJson(Map<String, dynamic> json) =>
      CutiTahunanHrModel(
        id: json["id"],
        masterCutiTahunanId: json["master_cuti_tahunan_id"],
        kuotaCutiTahunan: json["kuota_cuti_tahunan"],
        namaKaryawan: json["nama_karyawan"],
        judul: json["judul"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
        jumlahHari: json["jumlah_hari"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "master_cuti_tahunan_id": masterCutiTahunanId,
        "kuota_cuti_tahunan": kuotaCutiTahunan,
        "nama_karyawan": namaKaryawan,
        "judul": judul,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "tanggal_akhir":
            "${tanggalAkhir.year.toString().padLeft(4, '0')}-${tanggalAkhir.month.toString().padLeft(2, '0')}-${tanggalAkhir.day.toString().padLeft(2, '0')}",
        "jumlah_hari": jumlahHari,
        "status": status,
      };
}

enum Status { DRAFT, CONFIRMED, CANCELLED }

final statusValues = EnumValues({
  "Cancelled": Status.CANCELLED,
  "Confirmed": Status.CONFIRMED,
  "Draft": Status.DRAFT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
