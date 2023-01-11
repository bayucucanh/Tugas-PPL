import 'package:mobile_pssi/data/model/coach_position.dart';

class CoachOfferingPosition {
  int? id;
  CoachPosition? position;

  CoachOfferingPosition({this.id, this.position});

  factory CoachOfferingPosition.fromJson(Map<String, dynamic> json) =>
      CoachOfferingPosition(
        id: json['id'] as int?,
        position: json['position'] == null
            ? null
            : CoachPosition.fromJson(json['position'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': position?.toJson(),
      };
}
