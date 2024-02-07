// To parse this JSON data, do
//
//     final masterApproverListModel = masterApproverListModelFromJson(jsonString);

import 'dart:convert';

class MasterApproverListModel {
    final int id;
    final String namaApprover;
    final String namaKaryawan;

    MasterApproverListModel({
        required this.id,
        required this.namaApprover,
        required this.namaKaryawan,
    });

    factory MasterApproverListModel.fromRawJson(String str) => MasterApproverListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterApproverListModel.fromJson(Map<String, dynamic> json) => MasterApproverListModel(
        id: json["id"],
        namaApprover: json["nama_approver"],
        namaKaryawan: json["nama_karyawan"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama_approver": namaApprover,
        "nama_karyawan": namaKaryawan,
    };
}
