// To parse this JSON data, do
//
//     final masterApproverDetailModel = masterApproverDetailModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class MasterApproverDetailModel {
    final int id;
    final int idApprover;
    final String namaApprover;
    final int idKaryawan;
    final String namaKaryawan;

    MasterApproverDetailModel({
        required this.id,
        required this.idApprover,
        required this.namaApprover,
        required this.idKaryawan,
        required this.namaKaryawan,
    });

    factory MasterApproverDetailModel.fromRawJson(String str) => MasterApproverDetailModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterApproverDetailModel.fromJson(Map<String, dynamic> json) => MasterApproverDetailModel(
        id: json["id"],
        idApprover: json["id_approver"],
        namaApprover: json["nama_approver"],
        idKaryawan: json["id_karyawan"],
        namaKaryawan: json["nama_karyawan"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_approver": idApprover,
        "nama_approver": namaApprover,
        "id_karyawan": idKaryawan,
        "nama_karyawan": namaKaryawan,
    };
}
