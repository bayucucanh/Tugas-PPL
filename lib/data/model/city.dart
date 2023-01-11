import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/province.dart';

class City extends Equatable {
  final int? id;
  final String? name;
  final Province? province;

  const City({
    this.id,
    this.name,
    this.province,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
      id: json['id'] as int?,
      name: json['name'] as String?,
      province: json['province'] == null
          ? null
          : Province.fromJson(json['province'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  bool filterByName(String filter) {
    return name?.toString().contains(filter) ?? false;
  }

  ///this method will prevent the override of toString
  String provinceAsString() {
    return name ?? 'Belum Pilih';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(City model) {
    return id == model.id;
  }

  @override
  String toString() => name ?? 'Pilih Kota/Kabupaten';

  @override
  List<Object?> get props => [id, name, province];
}
