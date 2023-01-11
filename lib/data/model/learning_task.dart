import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/video.dart';

class LearningTask {
  int? id;
  String? name;
  String? description;
  Video? video;
  double? videoScore;
  String? uploadDate;
  int? learningId;
  String? learningName;
  int? userPlayerId;
  String? playerName;
  String? verificationReason;
  String? verificationStatus;
  dynamic verificationBy;
  DateTime? verificationDate;
  String? taskScore;

  LearningTask({
    this.id,
    this.name,
    this.description,
    this.video,
    this.videoScore,
    this.uploadDate,
    this.learningId,
    this.learningName,
    this.userPlayerId,
    this.playerName,
    this.verificationReason,
    this.verificationStatus,
    this.verificationBy,
    this.verificationDate,
    this.taskScore,
  });

  factory LearningTask.fromJson(Map<String, dynamic> json) {
    return LearningTask(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      video: json['video'] == null
          ? null
          : Video.fromJson(json['video'] as Map<String, dynamic>),
      videoScore: json['score_video'] == null
          ? null
          : double.parse(json['score_video'].toString()),
      uploadDate: json['upload_date'] as String?,
      learningId: json['learning_id'] == null
          ? null
          : json['learning_id'] is int
              ? json['learning_id'] as int?
              : int.parse(json['learning_id']),
      learningName: json['learning_name'] as String?,
      userPlayerId: json['user_player_id'] as int?,
      playerName: json['player_name'] as String?,
      verificationReason: json['verification_reason'] as String?,
      verificationStatus: json['verification_status'] as dynamic,
      verificationBy: json['verification_by'] as dynamic,
      verificationDate: json['verification_date'] == null
          ? null
          : validVerificationDate(json['verification_date']),
      taskScore: json['task_score'] as String?,
    );
  }

  static DateTime? validVerificationDate(String data) {
    DateTime? parse = DateTime.tryParse(data);
    if (parse == null) {
      return DateFormat('d MMMM yyyy H:m').parse(data);
    }
    return parse;
  }

  factory LearningTask.fromNotification(Map<String, dynamic> json) {
    return LearningTask(
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'video': video?.toJson(),
        'score_video': videoScore,
        'upload_date': uploadDate,
        'learning_id': learningId,
        'learning_name': learningName,
        'user_player_id': userPlayerId,
        'player_name': playerName,
        'verification_reason': verificationReason,
        'verification_status': verificationStatus,
        'verification_by': verificationBy,
        'verification_date': verificationDate?.toIso8601String(),
        'task_score': taskScore,
      };
}
