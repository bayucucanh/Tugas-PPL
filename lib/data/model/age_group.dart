import 'package:equatable/equatable.dart';

class AgeGroup extends Equatable {
  final int? id;
  final String? name;

  const AgeGroup({this.id, this.name});

  factory AgeGroup.fromJson(Map<String, dynamic> json) => AgeGroup(
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
