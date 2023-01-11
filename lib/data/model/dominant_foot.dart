import 'package:equatable/equatable.dart';

class DominantFoot extends Equatable {
  final int? id;
  final String? name;

  const DominantFoot({this.id, this.name});

  factory DominantFoot.fromJson(Map<String, dynamic> json) => DominantFoot(
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
