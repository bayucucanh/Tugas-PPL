import 'package:equatable/equatable.dart';

class Province extends Equatable {
  final int? id;
  final String? name;

  const Province({this.id, this.name});

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  bool provinceFilterByName(String filter) {
    return name?.toString().contains(filter) ?? false;
  }

  ///this method will prevent the override of toString
  String provinceAsString() {
    return name ?? 'Pilih Provinsi';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Province model) {
    return id == model.id;
  }

  @override
  String toString() => name ?? 'Pilih Provinsi';

  @override
  List<Object?> get props => [id, name];
}
