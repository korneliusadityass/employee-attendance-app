import 'dart:convert';

class AttachmentCutiTahunanModel {
  final int id;
  final String namaAttachment;

  AttachmentCutiTahunanModel({
    required this.id,
    required this.namaAttachment,
  });

  factory AttachmentCutiTahunanModel.fromRawJson(String str) =>
      AttachmentCutiTahunanModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory AttachmentCutiTahunanModel.fromJson(Map<String, dynamic> json) =>
      AttachmentCutiTahunanModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_attachment": namaAttachment,
  };
}
