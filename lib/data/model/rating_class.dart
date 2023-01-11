import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/user.dart';

class RatingClass {
  int? id;
  double? rating;
  String? description;
  Class? classData;
  User? player;

  RatingClass({
    this.id,
    this.classData,
    this.description,
    this.player,
    this.rating,
  });

  factory RatingClass.fromJson(Map<String, dynamic> json) => RatingClass(
        id: json['id'] as int?,
        rating: json['rating'] == null
            ? null
            : double.parse(json['rating'].toString()),
        description: json['description'] as String?,
        classData: json['class'] == null
            ? null
            : Class.fromJson(json['class'] as Map<String, dynamic>),
        player: json['player'] == null ? null : User.fromJson(json['player']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'rating': rating,
        'description': description,
        'class': classData?.toJson(),
        'player': player?.toJson(),
      };
}
