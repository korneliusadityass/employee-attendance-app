import 'dart:convert';

class AttachmentIzinSakitModelHr {
  final int? id;
  final String namaAttachment;

  AttachmentIzinSakitModelHr({
    required this.id,
    required this.namaAttachment,
  });

  factory AttachmentIzinSakitModelHr.fromRawJson(String str) =>
      AttachmentIzinSakitModelHr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentIzinSakitModelHr.fromJson(Map<String, dynamic> json) =>
      AttachmentIzinSakitModelHr(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
