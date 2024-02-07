import 'dart:convert';

// class AttachmentIzinSakitModel {
//   final int? id;
//   final String namaAttachment;

//   AttachmentIzinSakitModel({
//     this.id,
//     required this.namaAttachment,
//   });

//   factory AttachmentIzinSakitModel.fromRawJson(String str) =>
//       AttachmentIzinSakitModel.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory AttachmentIzinSakitModel.fromJson(Map<String, dynamic> json) =>
//       AttachmentIzinSakitModel(
//         id: json["id"],
//         namaAttachment: json["nama_attachment"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "nama_attachment": namaAttachment,
//       };
// }

class IzinSakitListAttachmentModel {
  final List<AttachmentIzinSakitModel> data;

  factory IzinSakitListAttachmentModel.fromRawJson(String str) =>
      IzinSakitListAttachmentModel.fromJson(json.decode(str));

  IzinSakitListAttachmentModel({required this.data});

  String toRawJson() => json.encode(toJson());

  factory IzinSakitListAttachmentModel.fromJson(List<dynamic> json) =>
      IzinSakitListAttachmentModel(
        data: List<AttachmentIzinSakitModel>.from(
            json.map((x) => AttachmentIzinSakitModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AttachmentIzinSakitModel {
  final int? id;
  final String namaAttachment;

  AttachmentIzinSakitModel({
    this.id,
    required this.namaAttachment,
  });

  factory AttachmentIzinSakitModel.fromRawJson(String str) =>
      AttachmentIzinSakitModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentIzinSakitModel.fromJson(Map<String, dynamic> json) =>
      AttachmentIzinSakitModel(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}