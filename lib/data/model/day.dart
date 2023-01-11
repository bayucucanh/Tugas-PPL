import 'package:equatable/equatable.dart';

class Day extends Equatable {
  final int? id;
  final String? name;

  const Day({this.id, this.name});

  factory Day.fromJson(Map<String, dynamic> json) => Day(
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
