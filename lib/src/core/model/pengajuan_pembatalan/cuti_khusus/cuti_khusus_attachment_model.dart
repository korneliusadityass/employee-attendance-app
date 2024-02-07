import 'dart:convert';

class CutiKhususListAttachmentModel {
  final List<CutiKhususAttachmentModel> data;

  factory CutiKhususListAttachmentModel.fromRawJson(String str) =>
      CutiKhususListAttachmentModel.fromJson(json.decode(str));

  CutiKhususListAttachmentModel({required this.data});

  String toRawJson() => json.encode(toJson());

  factory CutiKhususListAttachmentModel.fromJson(List<dynamic> json) =>
      CutiKhususListAttachmentModel(
        data: List<CutiKhususAttachmentModel>.from(
            json.map((x) => CutiKhususAttachmentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CutiKhususAttachmentModel {
  final int? id;
  final String namaAttachment;

  CutiKhususAttachmentModel({
    this.id,
    required this.namaAttachment,
  });

  factory CutiKhususAttachmentModel.fromRawJson(String str) =>
      CutiKhususAttachmentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CutiKhususAttachmentModel.fromJson(Map<String, dynamic> json) =>
      CutiKhususAttachmentModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
