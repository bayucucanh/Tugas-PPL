import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/learning_task.dart';
import 'package:mobile_pssi/data/model/skill_video.dart';
import 'package:mobile_pssi/data/model/thumbnail.dart';
import 'package:mobile_pssi/data/model/video.dart';

class VideoModel {
  int? id;
  String? name;
  String? description;
  Video? video;
  String? isPremium;
  String? isTask;
  String? status;
  int? classId;
  String? className;
  Class? classes;
  String? createdBy;
  int? totalView;
  List<SkillVideo>? videoSkills;
  Thumbnail? thumbnails;
  String? blurhash;
  String? duration;
  DateTime? createdDate;
  bool? finishedWatching;
  bool? checkedVideo;
  LearningTask? learningTask;

  VideoModel({
    this.id,
    this.name,
    this.description,
    this.video,
    this.isPremium,
    this.isTask,
    this.status,
    this.classId,
    this.className,
    this.classes,
    this.createdBy,
    this.totalView,
    this.videoSkills,
    this.thumbnails,
    this.blurhash,
    this.duration,
    this.createdDate,
    this.finishedWatching,
    this.checkedVideo,
    this.learningTask,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      video: json['video'] == null ? null : Video.fromJson(json['video']),
      isPremium: json['is_premium'] as String?,
      isTask: json['is_task'] as String?,
      status: json['status'] as String?,
      classId: json['class_id'] as int?,
      className: json['class_name'] as String?,
      classes: json['classes'] == null
          ? null
          : Class.fromJson(json['classes'] as Map<String, dynamic>),
      createdBy: json['created_by'] as String?,
      totalView: json['total_view'] as int?,
      videoSkills: (json['skill'] as List<dynamic>?)
          ?.map((e) => SkillVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
      thumbnails: json['thumbnails'] == null
          ? null
          : Thumbnail.fromJson(json['thumbnails'] as Map<String, dynamic>),
      blurhash: json['blurhash'] as String?,
      duration: json['duration'] as String?,
      createdDate: json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'].toString()).toLocal(),
      finishedWatching: json['finished_watching'] as bool?,
      checkedVideo: json['checked_video'] as bool?,
      learningTask: json['learning_task'] == null
          ? null
          : LearningTask.fromJson(
              json['learning_task'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'video': video?.toJson(),
        'is_premium': isPremium,
        'is_task': isTask,
        'status': status,
        'class_id': classId,
        'class_name': className,
        'classes': classes?.toJson(),
        'created_by': createdBy,
        'total_view': totalView,
        'skill': videoSkills?.map((e) => e.toJson()).toList(),
        'thumbnails': thumbnails?.toJson(),
        'blurhash': blurhash,
        'duration': duration,
        'created_date': createdDate,
        'finished_watching': finishedWatching,
        'checked_video': checkedVideo,
        'learning_task': learningTask?.toJson(),
      };

  bool get isPremiumStatus => isPremium == null
      ? false
      : isPremium!.contains('Non-Premium')
          ? false
          : true;

  bool get hasTask => isTask == null
      ? false
      : isTask!.contains('Ada')
          ? true
          : false;

  String? get formatCreatedAt => createdDate == null
      ? null
      : DateFormat('d MMMM yyyy', 'id_ID').format(createdDate!);

  Class toClass() => Class(
        id: classId,
        createdBy: createdBy,
        name: name,
        description: description,
      );
}
