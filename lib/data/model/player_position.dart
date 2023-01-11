import 'package:equatable/equatable.dart';

class PlayerPosition extends Equatable {
  final int? id;
  final String? name;

  const PlayerPosition({this.id, this.name});

  factory PlayerPosition.fromJson(Map<String, dynamic> json) => PlayerPosition(
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
