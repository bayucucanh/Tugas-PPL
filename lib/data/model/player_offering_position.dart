import 'package:mobile_pssi/data/model/player_position.dart';

class PlayerOfferingPosition {
  int? id;
  PlayerPosition? position;

  PlayerOfferingPosition({this.id, this.position});

  factory PlayerOfferingPosition.fromJson(Map<String, dynamic> json) =>
      PlayerOfferingPosition(
        id: json['id'] as int?,
        position: json['position'] == null
            ? null
            : PlayerPosition.fromJson(json['position'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': position?.toJson(),
      };
}
