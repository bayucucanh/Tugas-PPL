import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/rating_class.dart';
import 'package:mobile_pssi/data/model/thumbnail.dart';

class MyClass {
  int? id;
  int? classId;
  String? className;
  String? createdBy;
  String? totalVideoWatched;
  num? progress;
  String? status;
  Thumbnail? thumbnails;
  String? blurhash;
  String? isPremium;
  dynamic isTrending;
  RatingClass? rating;
  DateTime? deletedAt;

  MyClass({
    this.id,
    this.classId,
    this.className,
    this.createdBy,
    this.totalVideoWatched,
    this.progress,
    this.status,
    this.thumbnails,
    this.blurhash,
    this.isPremium,
    this.isTrending,
    this.rating,
    this.deletedAt,
  });

  factory MyClass.fromJson(Map<String, dynamic> json) => MyClass(
        id: json['id'] as int?,
        classId: json['class_id'] as int?,
        className: json['class_name'] as String?,
        createdBy: json['created_by'] as String?,
        totalVideoWatched: json['total_video_watched'] as String?,
        progress: json['progress'],
        status: json['status'] as String?,
        thumbnails: json['thumbnails'] == null
            ? null
            : Thumbnail.fromJson(json['thumbnails'] as Map<String, dynamic>),
        blurhash: json['blurhash'] as String?,
        isPremium: json['is_premium'] as String?,
        isTrending: json['is_trending'] as dynamic,
        rating: json['review'] == null
            ? null
            : RatingClass.fromJson(json['review']),
        deletedAt: json['deleted_at'] == null
            ? null
            : DateTime.parse(json['deleted_at'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'class_id': classId,
        'class_name': className,
        'created_by': createdBy,
        'total_video_watched': totalVideoWatched,
        'progress': progress,
        'status': status,
        'thumbnails': thumbnails?.toJson(),
        'blurhash': blurhash,
        'is_premium': isPremium,
        'is_trending': isTrending,
        'rating': rating?.toJson(),
        'deleted_at': deletedAt,
      };

  Class toClass() => Class(
        id: classId,
        name: className,
        createdBy: createdBy,
      );
  double get progressToPercent => double.tryParse(progress.toString())! * 100;
}
