import 'dart:convert';

class PerjalananDinasListAttachmentModel {
  final List<PerjalananDinasAttachmentModel> data;

  factory PerjalananDinasListAttachmentModel.fromRawJson(String str) =>
      PerjalananDinasListAttachmentModel.fromJson(json.decode(str));

  PerjalananDinasListAttachmentModel({required this.data});

  String toRawJson() => json.encode(toJson());

  factory PerjalananDinasListAttachmentModel.fromJson(List<dynamic> json) =>
      PerjalananDinasListAttachmentModel(
        data: List<PerjalananDinasAttachmentModel>.from(
            json.map((x) => PerjalananDinasAttachmentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PerjalananDinasAttachmentModel {
  final int? id;
  final String namaAttachment;

  PerjalananDinasAttachmentModel({
    this.id,
    required this.namaAttachment,
  });

  factory PerjalananDinasAttachmentModel.fromRawJson(String str) =>
      PerjalananDinasAttachmentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerjalananDinasAttachmentModel.fromJson(Map<String, dynamic> json) =>
      PerjalananDinasAttachmentModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}
