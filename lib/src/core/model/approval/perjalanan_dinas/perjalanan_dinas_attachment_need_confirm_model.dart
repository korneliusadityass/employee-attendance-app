// To parse this JSON data, do
//
//     final attachmentNeedConfirmPerjalananDinasModel = attachmentNeedConfirmPerjalananDinasModelFromJson(jsonString);

import 'dart:convert';

class AttachmentNeedConfirmPerjalananDinasModel {
  final int id;
  final String namaAttachment;

  AttachmentNeedConfirmPerjalananDinasModel({
    required this.id,
    required this.namaAttachment,
  });

  factory AttachmentNeedConfirmPerjalananDinasModel.fromRawJson(String str) =>
      AttachmentNeedConfirmPerjalananDinasModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentNeedConfirmPerjalananDinasModel.fromJson(
          Map<String, dynamic> json) =>
      AttachmentNeedConfirmPerjalananDinasModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
