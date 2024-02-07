import 'dart:convert';

class MasterCompanyListModel {
    MasterCompanyListModel({
        required this.id,
        required this.namaPerusahaan,
    });

    final int id;
    final String namaPerusahaan;

    factory MasterCompanyListModel.fromRawJson(String str) => MasterCompanyListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterCompanyListModel.fromJson(Map<String, dynamic> json) => MasterCompanyListModel(
        id: json["id"],
        namaPerusahaan: json["nama_perusahaan"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_perusahaan": namaPerusahaan,
    };
}
