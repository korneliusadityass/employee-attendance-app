import 'dart:convert';

class AttachmentNeedConfirmCutiKhususModel {
  final int id;
  final String namaAttachment;

  AttachmentNeedConfirmCutiKhususModel({
    required this.id,
    required this.namaAttachment,
  });

  factory AttachmentNeedConfirmCutiKhususModel.fromRawJson(String str) =>
      AttachmentNeedConfirmCutiKhususModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentNeedConfirmCutiKhususModel.fromJson(
          Map<String, dynamic> json) =>
      AttachmentNeedConfirmCutiKhususModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
