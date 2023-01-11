import 'package:mobile_pssi/data/model/rating_class.dart';
import 'package:mobile_pssi/data/model/thumbnail.dart';
import 'package:mobile_pssi/data/model/video.model.dart';

class Class {
  int? id;
  String? name;
  String? description;
  String? isPremium;
  String? status;
  String? createdBy;
  double? rating;
  int? totalRiview;
  int? totalPlayer;
  int? totalVideo;
  dynamic isTrending;
  int? classLevelId;
  String? classLevelName;
  int? classCategoryId;
  String? classCategoryName;
  Thumbnail? thumbnails;
  String? blurhash;
  List<VideoModel>? playerVideo;
  List<VideoModel>? listVideo;
  List<RatingClass>? reviews;

  Class({
    this.id,
    this.name,
    this.description,
    this.isPremium,
    this.status,
    this.createdBy,
    this.rating,
    this.totalRiview,
    this.totalPlayer,
    this.totalVideo,
    this.isTrending,
    this.classLevelId,
    this.classLevelName,
    this.classCategoryId,
    this.classCategoryName,
    this.playerVideo,
    this.listVideo,
    this.reviews,
    this.thumbnails,
    this.blurhash,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      isPremium: json['is_premium'] as String?,
      status: json['status'] as String?,
      createdBy: json['created_by'] as String?,
      rating: json['rating'] == null
          ? null
          : double.parse(json['rating'].toString()),
      totalRiview: json['total_riview'] as int?,
      totalPlayer: json['total_player'] as int?,
      totalVideo: json['total_video'] as int?,
      isTrending: json['is_trending'] as dynamic,
      classLevelId: json['class_level_id'] as int?,
      classLevelName: json['class_level_name'] as String?,
      classCategoryId: json['class_category_id'] as int?,
      classCategoryName: json['class_category_name'] as String?,
      thumbnails: json['thumbnails'] == null
          ? null
          : Thumbnail.fromJson(json['thumbnails'] as Map<String, dynamic>),
      blurhash: json['blurhash'] as String?,
      playerVideo: (json['player_list_video'] as List<dynamic>?)
          ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      listVideo: (json['list_video'] as List<dynamic>?)
          ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => RatingClass.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'is_premium': isPremium,
        'status': status,
        'created_by': createdBy,
        'rating': rating,
        'total_riview': totalRiview,
        'total_player': totalPlayer,
        'total_video': totalVideo,
        'is_trending': isTrending,
        'class_level_id': classLevelId,
        'class_level_name': classLevelName,
        'class_category_id': classCategoryId,
        'class_category_name': classCategoryName,
        'thumbnails': thumbnails?.toJson(),
        'blurhash': blurhash,
        'player_list_video': playerVideo?.map((e) => e.toJson()).toList(),
        'list_video': listVideo?.map((e) => e.toJson()).toList(),
        'reviews': reviews?.map((e) => e.toJson()).toList(),
      };

  bool get isPremiumContent =>
      isPremium!.toLowerCase() == 'premium' ? true : false;

  bool get isFreeContent => isPremium!.toLowerCase() == 'gratis' ? true : false;

  bool get isActive => status == null
      ? false
      : status!.contains('Aktif')
          ? true
          : false;
}
