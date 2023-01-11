import 'package:mobile_pssi/data/model/city.dart';

class District {
  int? id;
  String? name;
  City? city;

  District({
    this.id,
    this.name,
    this.city,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json['id'] as int?,
        name: json['name'] as String?,
        city: json['city'] == null
            ? null
            : City.fromJson(json['city'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city?.toJson(),
      };

  bool filterByName(String filter) {
    return name?.toString().contains(filter) ?? false;
  }

  ///this method will prevent the override of toString
  String provinceAsString() {
    return name ?? 'Pilih Kecamatan';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(District model) {
    return id == model.id;
  }

  @override
  String toString() => name ?? 'Pilih Kecamatan';
}
