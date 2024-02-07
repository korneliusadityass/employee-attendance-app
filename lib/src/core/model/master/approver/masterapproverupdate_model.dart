// To parse this JSON data, do
//
//     final masterApproverUpdateModel = masterApproverUpdateModelFromJson(jsonString);


import 'dart:convert';

class MasterApproverUpdateModel {
    MasterApproverUpdateModel({
        required this.approverId,
        required this.karyawanId,
    });

    final int approverId;
    final int karyawanId;

    factory MasterApproverUpdateModel.fromRawJson(String str) => MasterApproverUpdateModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MasterApproverUpdateModel.fromJson(Map<String, dynamic> json) => MasterApproverUpdateModel(
        approverId: json["approver_id"],
        karyawanId: json["karyawan_id"],
    );

    Map<String, dynamic> toJson() => {
        "approver_id": approverId,
        "karyawan_id": karyawanId,
    };
}
