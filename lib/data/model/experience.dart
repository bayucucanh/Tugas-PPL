import 'package:mobile_pssi/data/model/user.dart';

class Experience {
  int? id;
  String? name;
  String? description;
  String? file;
  String? fileType;
  User? uploadedBy;

  Experience({
    this.id,
    this.name,
    this.description,
    this.file,
    this.fileType,
    this.uploadedBy,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        file: json['experience_file'] as String?,
        fileType: json['file_type'] as String?,
        uploadedBy: json['uploaded_by'] == null
            ? null
            : User.fromJson(json['uploaded_by'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'experience_file': file,
        'uploaded_by': uploadedBy?.toJson(),
      };
}
