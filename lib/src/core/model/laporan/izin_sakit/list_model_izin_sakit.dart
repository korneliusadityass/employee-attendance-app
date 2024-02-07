import 'dart:convert';

class ListLaporanIzinSakitModel {
  final int id;
  final String namaKaryawan;
  final String posisi;
  final String judul;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;
  final int jumlahHari;
  final String status;

  ListLaporanIzinSakitModel({
    required this.id,
    required this.namaKaryawan,
    required this.posisi,
    required this.judul,
    required this.tanggalAwal,
    required this.tanggalAkhir,
    required this.jumlahHari,
    required this.status,
  });

  factory ListLaporanIzinSakitModel.fromRawJson(String str) =>
      ListLaporanIzinSakitModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListLaporanIzinSakitModel.fromJson(Map<String, dynamic> json) =>
      ListLaporanIzinSakitModel(
        id: json["id"],
        namaKaryawan: json["nama_karyawan"],
        posisi: json["posisi"],
        judul: json["judul"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
        jumlahHari: json["jumlah_hari"],
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
        "status": status,
      };
}
