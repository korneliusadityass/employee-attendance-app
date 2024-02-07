// To parse this JSON data, do
//
//     final masterApproverInputModel = masterApproverInputModelFromJson(jsonString);


import 'dart:convert';

class MasterApproverInputModel {
    MasterApproverInputModel({
        required this.approverId,
        required this.karyawanId,
    });

    final int approverId;
    final String karyawanId;

    factory MasterApproverInputModel.fromRawJson(String str) => MasterApproverInputModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterApproverInputModel.fromJson(Map<String, dynamic> json) => MasterApproverInputModel(
        approverId: json["approver_id"],
        karyawanId: json["karyawan_id"],
    );

    Map<String, dynamic> toJson() => {
        "approver_id": approverId,
        "karyawan_id": karyawanId,
    };
}
