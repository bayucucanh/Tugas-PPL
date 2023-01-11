import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/club_coach.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/extensions/age.extension.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

import 'category.dart';
import 'nationality.dart';

class Employee extends Equatable {
  final int? id;
  final bool? isOnline;
  final int? userId;
  final User? user;
  final String? name;
  final Gender? gender;
  final String? phoneNumber;
  final String? address;
  final String? dateOfBirth;
  final City? city;
  final Province? province;
  final Nationality? nationality;
  final ClubCoach? clubCoach;
  final Category? category;
  final String? photo;
  final String? ktp;
  final String? nik;

  const Employee({
    this.id,
    this.isOnline,
    this.userId,
    this.user,
    this.name,
    this.gender,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.city,
    this.province,
    this.nationality,
    this.clubCoach,
    this.category,
    this.photo,
    this.ktp,
    this.nik,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int?,
      isOnline: json['is_online'] == null ? false : json['is_online'] as bool?,
      userId: json['user_id'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      name: json['name'] as String?,
      gender: json['gender'] == null
          ? null
          : Gender.fromJson(json['gender'] as Map<String, dynamic>),
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      province: json['province'] == null
          ? null
          : Province.fromJson(json['province'] as Map<String, dynamic>),
      nationality: json['nationality'] == null
          ? null
          : Nationality.fromJson(json['nationality'] as Map<String, dynamic>),
      clubCoach: json['club_coach'] == null
          ? null
          : ClubCoach.fromJson(json['club_coach'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      photo: json['photo'] as String?,
      ktp: json['ktp'] as String?,
      nik: json['nik'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_online': isOnline,
        'user_id': userId,
        'user': user?.toJson(),
        'name': name,
        'gender': gender?.toJson(),
        'phone_number': phoneNumber,
        'address': address,
        'date_of_birth': dateOfBirth,
        'city': city?.toJson(),
        'province': province?.toJson(),
        'nationality': nationality?.toJson(),
        'club_coach': clubCoach?.toJson(),
        'category': category?.toJson(),
        'photo': photo,
        'ktp': ktp,
        'nik': nik,
      };

  Profile? toProfile() => Profile(
        id: id,
        name: name,
        address: address,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        city: city,
        ktp: ktp,
        nationality: nationality,
        nik: nik,
        photo: photo,
        category: category,
        isPlayer: false,
        gender: gender,
      );

  String? get age {
    if (dateOfBirth == null) {
      return null;
    }
    return '${dateOfBirth?.formatAge()} tahun';
  }

  String gravatar() {
    var gravatar = Gravatar(name ?? user!.email!);
    return gravatar.imageUrl(
        size: 150,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true);
  }

  @override
  List<Object?> get props => [
        id,
        isOnline,
        userId,
        user,
        name,
        gender,
        phoneNumber,
        address,
        dateOfBirth,
        city,
        province,
        nationality,
        clubCoach,
        category,
        photo,
        ktp,
        nik,
        age,
      ];
}
