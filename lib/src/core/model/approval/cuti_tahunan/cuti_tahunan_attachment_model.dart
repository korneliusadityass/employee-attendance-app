import 'dart:convert';

class AttachmentNeedConfirmCutiTahunanModel {
  final int id;
  final String namaAttachment;

  AttachmentNeedConfirmCutiTahunanModel({
    required this.id,
    required this.namaAttachment,
  });

  factory AttachmentNeedConfirmCutiTahunanModel.fromRawJson(String str) =>
      AttachmentNeedConfirmCutiTahunanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentNeedConfirmCutiTahunanModel.fromJson(
          Map<String, dynamic> json) =>
      AttachmentNeedConfirmCutiTahunanModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
