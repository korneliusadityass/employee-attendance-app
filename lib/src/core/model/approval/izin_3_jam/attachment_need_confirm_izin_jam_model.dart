// To parse this JSON data, do
//
//     final attachmentNeedConfirmIzin3JamModel = attachmentNeedConfirmIzin3JamModelFromJson(jsonString);

import 'dart:convert';

class AttachmentNeedConfirmIzin3JamModel {
  final int id;
  final String namaAttachment;

  AttachmentNeedConfirmIzin3JamModel({
    required this.id,
    required this.namaAttachment,
  });

  factory AttachmentNeedConfirmIzin3JamModel.fromRawJson(String str) =>
      AttachmentNeedConfirmIzin3JamModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentNeedConfirmIzin3JamModel.fromJson(
          Map<String, dynamic> json) =>
      AttachmentNeedConfirmIzin3JamModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
