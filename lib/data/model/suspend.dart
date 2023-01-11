import 'package:mobile_pssi/data/model/duration.dart';

class Suspend {
  int? id;
  String? name;
  SuspendDuration? duration;
  int? value;

  Suspend({
    this.id,
    this.duration,
    this.name,
    this.value,
  });

  factory Suspend.fromJson(Map<String, dynamic> json) => Suspend(
        id: json['id'] as int?,
        name: json['name'] as String?,
        duration: json['duration'] == null
            ? null
            : SuspendDuration.fromJson(
                json['duration'] as Map<String, dynamic>),
        value: json['value'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'duration': duration?.toJson(),
        'value': value,
      };

  String get durationFormat {
    if (value == null && duration == null) {
      return 'Ban Permanen';
    } else {
      switch (duration?.id) {
        case 'day':
          return '$value hari';
        case 'month':
          return '$value bulan';
        case 'year':
          return '$value tahun';
        default:
          return 'Ban Permanen';
      }
    }
  }
}
