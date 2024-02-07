import 'dart:convert';

class ListApprovalIzin3JamModel {
  ListApprovalIzin3JamModel({
    required this.id,
    required this.judul,
    required this.namaKaryawan,
    required this.tanggalIjin,
    required this.waktuAwal,
    required this.waktuAkhir,
    required this.status,
  });

  final int id;
  final String judul;
  final String namaKaryawan;
  final DateTime tanggalIjin;
  final String waktuAwal;
  final String waktuAkhir;
  final String status;

  factory ListApprovalIzin3JamModel.fromRawJson(String str) =>
      ListApprovalIzin3JamModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListApprovalIzin3JamModel.fromJson(Map<String, dynamic> json) =>
      ListApprovalIzin3JamModel(
        id: json["id"],
        judul: json["judul"],
        namaKaryawan: json["nama_karyawan"],
        tanggalIjin: DateTime.parse(json["tanggal_ijin"]),
        waktuAwal: json["waktu_awal"],
        waktuAkhir: json["waktu_akhir"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "nama_karyawan": namaKaryawan,
        "tanggal_ijin":
            "${tanggalIjin.year.toString().padLeft(4, '0')}-${tanggalIjin.month.toString().padLeft(2, '0')}-${tanggalIjin.day.toString().padLeft(2, '0')}",
        "waktu_awal": waktuAwal,
        "waktu_akhir": waktuAkhir,
        "status": status,
      };
}
