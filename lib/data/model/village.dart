import 'package:mobile_pssi/data/model/district.dart';

class Village {
  int? id;
  String? name;
  District? district;

  Village({
    this.id,
    this.name,
    this.district,
  });

  factory Village.fromJson(Map<String, dynamic> json) => Village(
      id: json['id'] as int?,
      name: json['name'] as String?,
      district: json['district'] == null
          ? null
          : District.fromJson(json['district'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  bool filterByName(String filter) {
    return name?.toString().contains(filter) ?? false;
  }

  ///this method will prevent the override of toString
  String provinceAsString() {
    return name ?? 'Pilih Kelurahan';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Village model) {
    return id == model.id;
  }

  @override
  String toString() => name ?? 'Pilih Kelurahan';

  String toCompleteAddress() =>
      '${name ?? '-'}, ${district?.name ?? '-'}, ${district?.city?.name ?? '-'}, ${district?.city?.province?.name ?? '-'}';
}
