import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/thumbnail.dart';

class LatestWatch {
  int? classId;
  String? className;
  String? creatorName;
  Thumbnail? thumbnails;
  String? blurhash;

  LatestWatch({
    this.classId,
    this.className,
    this.creatorName,
    this.thumbnails,
    this.blurhash,
  });

  factory LatestWatch.fromJson(Map<String, dynamic> json) => LatestWatch(
        classId: json['id'] as int?,
        className: json['class_name'] as String?,
        creatorName: json['creator_name'] as String?,
        thumbnails: json['thumbnails'] == null
            ? null
            : Thumbnail.fromJson(json['thumbnails'] as Map<String, dynamic>),
        blurhash: json['blurhash'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': classId,
        'name': className,
        'creator_name': creatorName,
        'thumbnail': thumbnails?.toJson(),
        'blurhash': blurhash,
      };

  Class toClass() => Class(
        id: classId,
        createdBy: creatorName,
        name: className,
      );
}
