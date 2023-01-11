import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/video.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_thumbnail/video_thumbnail.dart';

class TaskDetail {
  int? id;
  String? name;
  String? description;
  Video? video;
  double? scoreVideo;
  String? duration;
  String? uploadDate;
  int? learningId;
  String? learningName;
  String? creatorName;
  int? userPlayerId;
  String? playerName;
  dynamic verificationReason;
  String? verificationStatus;
  dynamic verificationBy;
  String? verificationDate;
  String? taskScore;

  TaskDetail({
    this.id,
    this.name,
    this.description,
    this.video,
    this.scoreVideo,
    this.duration,
    this.uploadDate,
    this.learningId,
    this.learningName,
    this.creatorName,
    this.userPlayerId,
    this.playerName,
    this.verificationReason,
    this.verificationStatus,
    this.verificationBy,
    this.verificationDate,
    this.taskScore,
  });

  factory TaskDetail.fromJson(Map<String, dynamic> json) {
    return TaskDetail(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      video: json['video'] == null
          ? null
          : Video.fromJson(json['video'] as Map<String, dynamic>),
      scoreVideo: json['score_video'] == null
          ? null
          : double.tryParse(json['score_video'].toString()),
      duration: json['duration'] as String?,
      uploadDate: json['upload_date'] as String?,
      learningId: json['learning_id'] as int?,
      learningName: json['learning_name'] as String?,
      creatorName: json['creator_name'] as String?,
      userPlayerId: json['user_player_id'] as int?,
      playerName: json['player_name'] as String?,
      verificationReason: json['verification_reason'] as dynamic,
      verificationStatus: json['verification_status'] as String?,
      verificationBy: json['verification_by'] as dynamic,
      verificationDate: json['verification_date'] as String?,
      taskScore: json['task_score'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'video': video?.toJson(),
        'score_video': scoreVideo,
        'duration': duration,
        'upload_date': uploadDate,
        'learning_id': learningId,
        'learning_name': learningName,
        'creator_name': creatorName,
        'user_player_id': userPlayerId,
        'player_name': playerName,
        'verification_reason': verificationReason,
        'verification_status': verificationStatus,
        'verification_by': verificationBy,
        'verification_date': verificationDate,
        'task_score': taskScore,
      };

  Color? getStatusColor() {
    Color defaultColor = pendingColor;
    switch (verificationStatus) {
      case 'Diterima':
        defaultColor = primaryColor;
        break;
      case 'Ditolak':
        defaultColor = deniedColor;
        break;
      case 'Diajukan':
      default:
        defaultColor = pendingColor;
    }

    return defaultColor;
  }

  Future<String?> getThumbnail() async {
    String? imagePath;
    if (video == null) {
      imagePath = null;
    } else {
      imagePath = await VideoThumbnail.thumbnailFile(
        video: video!.url!,
        thumbnailPath: (await getTemporaryDirectory()).path,
        maxWidth: 150,
        quality: 75,
      );
    }
    return imagePath;
  }

  String? get createdDateFormat {
    DateTime? format = DateTime.tryParse(uploadDate.toString());
    if (format != null) {
      return timeago.format(format.toLocal());
    }
    return null;
  }
}
