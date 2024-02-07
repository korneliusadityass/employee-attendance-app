import 'dart:convert';

// class AttachmentCutiTahunanModelHr {
//   final int? id;
//   final String namaAttachment;

//   AttachmentCutiTahunanModelHr({
//     this.id,
//     required this.namaAttachment,
//   });

//   factory AttachmentCutiTahunanModelHr.fromRawJson(String str) =>
//       AttachmentCutiTahunanModelHr.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory AttachmentCutiTahunanModelHr.fromJson(Map<String, dynamic> json) =>
//       AttachmentCutiTahunanModelHr(
//         id: json["id"],
//         namaAttachment: json["nama_attachment"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "nama_attachment": namaAttachment,
//       };
// }

class CutiTahunanListAttachmentModel {
  final List<AttachmentCutiTahunanModelHr> data;

  factory CutiTahunanListAttachmentModel.fromRawJson(String str) =>
      CutiTahunanListAttachmentModel.fromJson(json.decode(str));

  CutiTahunanListAttachmentModel({required this.data});

  String toRawJson() => json.encode(toJson());

  factory CutiTahunanListAttachmentModel.fromJson(List<dynamic> json) =>
      CutiTahunanListAttachmentModel(
        data: List<AttachmentCutiTahunanModelHr>.from(
            json.map((x) => AttachmentCutiTahunanModelHr.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AttachmentCutiTahunanModelHr {
  final int? id;
  final String namaAttachment;

  AttachmentCutiTahunanModelHr({
    this.id,
    required this.namaAttachment,
  });

  factory AttachmentCutiTahunanModelHr.fromRawJson(String str) =>
      AttachmentCutiTahunanModelHr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttachmentCutiTahunanModelHr.fromJson(Map<String, dynamic> json) =>
      AttachmentCutiTahunanModelHr(
        id: json["id"],
        namaAttachment: json["nama_attachment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_attachment": namaAttachment,
      };
}