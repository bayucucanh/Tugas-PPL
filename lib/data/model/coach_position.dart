import 'package:equatable/equatable.dart';

class CoachPosition extends Equatable {
  final int? id;
  final String? name;

  const CoachPosition({this.id, this.name});

  factory CoachPosition.fromJson(Map<String, dynamic> json) => CoachPosition(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}
