import 'dart:convert';

class AttachmentNeedConfirmIzinSakitModel {
  final int id;
  final String namaAttachment;

  AttachmentNeedConfirmIzinSakitModel({
    required this.id,
    required this.namaAttachment,
  });

  factory AttachmentNeedConfirmIzinSakitModel.fromRawJson(String str) =>
      AttachmentNeedConfirmIzinSakitModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentNeedConfirmIzinSakitModel.fromJson(
          Map<String, dynamic> json) =>
      AttachmentNeedConfirmIzinSakitModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
