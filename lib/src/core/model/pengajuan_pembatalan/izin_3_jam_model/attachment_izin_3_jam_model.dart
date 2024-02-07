// To parse this JSON data, do
//
//     final attachmentIzin3JamModel = attachmentIzin3JamModelFromJson(jsonString);

import 'dart:convert';

class AttachmentListIzin3JamModel {
  final List<AttachmentIzin3JamModel> data;

  factory AttachmentListIzin3JamModel.fromRawJson(String str) =>
      AttachmentListIzin3JamModel.fromJson(json.decode(str));

  AttachmentListIzin3JamModel({required this.data});

  String toRawJson() => json.encode(toJson());

  factory AttachmentListIzin3JamModel.fromJson(List<dynamic> json) =>
      AttachmentListIzin3JamModel(
        data: List<AttachmentIzin3JamModel>.from(
            json.map((x) => AttachmentIzin3JamModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AttachmentIzin3JamModel {
  final int? id;
  final String namaAttachment;

  AttachmentIzin3JamModel({
    this.id,
    required this.namaAttachment,
  });

  factory AttachmentIzin3JamModel.fromRawJson(String str) =>
      AttachmentIzin3JamModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentIzin3JamModel.fromJson(Map<String, dynamic> json) =>
      AttachmentIzin3JamModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
