import 'dart:convert';

class InputCutiTahunanModel {
  InputCutiTahunanModel({
    required this.judul,
    required this.tanggalAwal,
    required this.tanggalAkhir,
  });

  final String judul;
  final DateTime tanggalAwal;
  final DateTime tanggalAkhir;

  factory InputCutiTahunanModel.fromRawJson(String str) =>
      InputCutiTahunanModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory InputCutiTahunanModel.fromJson(Map<String, dynamic> json) =>
      InputCutiTahunanModel(
        judul: json["judul"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
      );
  Map<String, dynamic> toJson() => {
        "judul": judul,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "tanggal_akhir":
            "${tanggalAkhir.year.toString().padLeft(4, '0')}-${tanggalAkhir.month.toString().padLeft(2, '0')}-${tanggalAkhir.day.toString().padLeft(2, '0')}",
      };
}
