import 'package:mobile_pssi/extensions/youtube.extension.dart';

import 'learning.dart';
import 'player.dart';

class LearningTask {
  int? id;
  String? name;
  String? description;
  String? video;
  String? provider;
  String? thumbnail;
  double? videoScore;
  String? duration;
  Learning? learning;
  Player? player;

  LearningTask({
    this.id,
    this.name,
    this.description,
    this.video,
    this.thumbnail,
    this.provider,
    this.videoScore,
    this.duration,
    this.learning,
    this.player,
  });

  factory LearningTask.fromJson(Map<String, dynamic> json) => LearningTask(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        video: json['video'] as String?,
        thumbnail: json['thumbnail'] as String?,
        provider: json['provider'] as String?,
        videoScore: json['video_score'] == null
            ? null
            : double.tryParse(json['video_score'].toString()),
        duration: json['duration'] as String?,
        learning: json['learning'] == null
            ? null
            : Learning.fromJson(json['learning'] as Map<String, dynamic>),
        player: json['player'] == null
            ? null
            : Player.fromJson(json['player'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'video': video,
        'thumbnail': thumbnail,
        'provider': provider,
        'score_video': videoScore,
        'duration': duration,
        'learning': learning?.toJson(),
        'player': player?.toJson(),
      };

  String? get thumbnailVideo {
    if (thumbnail == null && provider == 'youtube') {
      return video?.getYoutubeThumbnail();
    }
    return thumbnail;
  }

  bool get isLocalProvider => provider == 'local';
}
