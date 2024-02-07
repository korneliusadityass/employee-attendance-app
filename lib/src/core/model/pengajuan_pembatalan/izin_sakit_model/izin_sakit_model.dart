import 'dart:convert';

class IzinSakitModel {
  IzinSakitModel({
    required this.id,
    required this.judul,
    required this.namaKaryawan,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.status,
  });

  final int id;
  final String judul;
  final String namaKaryawan;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;
  final String status;

  factory IzinSakitModel.fromRawJson(String str) =>
      IzinSakitModel.fromRawJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory IzinSakitModel.fromJson(Map<String, dynamic> json) => IzinSakitModel(
      id: json["id"],
      judul: json["judul"],
      namaKaryawan: json["nama_karyawan"],
      tanggalAwal: DateTime.parse(json["tanggal_awal"]),
      tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "nama_karyawan": namaKaryawan,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "tanggal_akhir":
            "${tanggalAkhir.year.toString().padLeft(4, '0')}-${tanggalAkhir.month.toString().padLeft(2, '0')}-${tanggalAkhir.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
