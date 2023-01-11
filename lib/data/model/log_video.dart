import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/model/video.model.dart';
import 'package:mobile_pssi/utils/timeago/id_locale.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;

class LogVideo {
  int? id;
  VideoModel? learning;
  User? user;
  DateTime? createdAt;
  final _df = DateFormat('d MMMM yyyy HH:mm', 'id');

  LogVideo({
    this.id,
    this.learning,
    this.user,
    this.createdAt,
  });

  factory LogVideo.fromJson(Map<String, dynamic> json) => LogVideo(
        id: json['id'] as int?,
        learning: json['learning'] == null
            ? null
            : VideoModel.fromJson(json['learning'] as Map<String, dynamic>),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'learning': learning?.toJson(),
        'user': user?.toJson(),
        'created_at': createdAt?.toIso8601String(),
      };

  String? get elapsedTime {
    timeago.setLocaleMessages('id', IdMessages());
    return createdAt == null ? null : timeago.format(createdAt!);
  }

  String? get createdAtFormat {
    return createdAt == null ? null : _df.format(createdAt!);
  }
}
