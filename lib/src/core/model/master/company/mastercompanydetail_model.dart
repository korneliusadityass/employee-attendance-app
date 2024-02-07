// To parse this JSON data, do
//
//     final masterCompanyDetailModel = masterCompanyDetailModelFromJson(jsonString);

import 'dart:convert';

class MasterCompanyDetailModel {
    final int id;
    final String namaPerusahaan;

    MasterCompanyDetailModel({
        required this.id,
        required this.namaPerusahaan,
    });

    factory MasterCompanyDetailModel.fromRawJson(String str) => MasterCompanyDetailModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterCompanyDetailModel.fromJson(Map<String, dynamic> json) => MasterCompanyDetailModel(
        id: json["id"],
        namaPerusahaan: json["nama_perusahaan"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_perusahaan": namaPerusahaan,
    };
}
