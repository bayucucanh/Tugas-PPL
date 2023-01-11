import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/verified.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

class Club extends Equatable {
  final int? id;
  final String? name;
  final String? address;
  final DateTime? birthDate;
  final String? photo;
  final Verified? verified;
  final City? city;
  final Province? province;
  final int? totalPlayers;
  final double? rating;

  const Club({
    this.id,
    this.name,
    this.address,
    this.birthDate,
    this.photo,
    this.city,
    this.province,
    this.verified,
    this.totalPlayers,
    this.rating,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      birthDate: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'].toString()),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      photo: json['photo'] as String?,
      province: json['province'] == null
          ? null
          : Province.fromJson(json['province'] as Map<String, dynamic>),
      verified: json['verified'] == null
          ? null
          : Verified.fromJson(json['verified'] as Map<String, dynamic>),
      totalPlayers: json['total_players'] as int?,
      rating: json['rating'] == null
          ? null
          : double.parse(json['rating'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'date_of_birth': birthDate?.toString(),
        'city': city?.toJson(),
        'province': province?.toJson(),
        'photo': photo,
        'verified': verified?.toJson(),
        'total_players': totalPlayers,
        'rating': rating,
      };

  Profile? toProfile() => Profile(
        id: id,
        name: name,
        address: address,
        dateOfBirth: dateOfBirthInputFormat,
        city: city,
        photo: photo,
        isPlayer: false,
      );

  String gravatar() {
    var gravatar = Gravatar(name.toString());
    return gravatar.imageUrl(
        size: 150,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true);
  }

  String? get dateOfBirthInputFormat =>
      birthDate == null ? null : DateFormat('yyyy-MM-dd').format(birthDate!);

  String? get dateOfBirthFormat => birthDate == null
      ? null
      : DateFormat('dd MMMM yyyy', 'id_ID').format(birthDate!);

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        birthDate,
        photo,
        verified,
        city,
        province,
        totalPlayers,
        rating,
      ];
}
