import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SecureDocument {
  int? id;
  User? user;
  String? name;
  String? slug;
  String? file;
  Status? status;
  DateTime? updatedAt;

  SecureDocument({
    this.id,
    this.user,
    this.file,
    this.name,
    this.slug,
    this.status,
    this.updatedAt,
  });

  factory SecureDocument.fromJson(Map<String, dynamic> json) {
    return SecureDocument(
      id: json['id'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      name: json['name'] as String?,
      file: json['file'] as String?,
      slug: json['slug'] as String?,
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'].toString()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'name': name,
        'file': file,
        'slug': slug,
        'status': status?.toJson(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  bool get isPdf => file == null
      ? false
      : extension(file!) == '.pdf'
          ? true
          : false;

  openFile(String? url) async {
    if (url != null) {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    }
  }
}
