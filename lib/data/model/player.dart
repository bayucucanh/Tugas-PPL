import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/extensions/age.extension.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'dominant_foot.dart';
import 'height.dart';
import 'nationality.dart';
import 'weight.dart';

class Player extends Equatable {
  final int? id;
  final int? userId;
  final String? name;
  final Gender? gender;
  final String? phoneNumber;
  final String? address;
  final String? dateOfBirth;
  final City? city;
  final Province? province;
  final Nationality? nationality;
  final Height? height;
  final Weight? weight;
  final DominantFoot? dominantFoot;
  final String? photo;
  final String? parentPhoneNumber;
  final String? nik;
  final PlayerPosition? position;
  final String? website;
  final PerformanceTestVerification? performanceTestVerification;
  final ClubPlayer? clubPlayer;
  final double? overallRating;

  const Player({
    this.id,
    this.userId,
    this.name,
    this.gender,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.city,
    this.province,
    this.nationality,
    this.height,
    this.weight,
    this.dominantFoot,
    this.photo,
    this.parentPhoneNumber,
    this.nik,
    this.position,
    this.performanceTestVerification,
    this.website,
    this.overallRating,
    this.clubPlayer,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
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
      province: json['province'] as dynamic,
      nationality: json['nationality'] == null
          ? null
          : Nationality.fromJson(json['nationality'] as Map<String, dynamic>),
      height: json['height'] == null
          ? null
          : Height.fromJson(json['height'] as Map<String, dynamic>),
      weight: json['weight'] == null
          ? null
          : Weight.fromJson(json['weight'] as Map<String, dynamic>),
      dominantFoot: json['dominant_foot'] == null
          ? null
          : DominantFoot.fromJson(
              json['dominant_foot'] as Map<String, dynamic>),
      photo: json['photo'] as String?,
      parentPhoneNumber: json['parent_phone_number'] as String?,
      nik: json['nik'] as String?,
      position: json['position'] == null
          ? null
          : PlayerPosition.fromJson(json['position'] as Map<String, dynamic>),
      performanceTestVerification: json['performance'] == null
          ? null
          : PerformanceTestVerification.fromJson(
              json['performance'] as Map<String, dynamic>),
      website: json['website'] as String?,
      clubPlayer: json['club_player'] == null
          ? null
          : ClubPlayer.fromJson(json['club_player'] as Map<String, dynamic>),
      overallRating: json['overall_rating'] == null
          ? null
          : double.parse(json['overall_rating'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'gender': gender?.toJson(),
        'phone_number': phoneNumber,
        'address': address,
        'date_of_birth': dateOfBirth,
        'city': city?.toJson(),
        'province': province,
        'nationality': nationality?.toJson(),
        'height': height?.toJson(),
        'weight': weight?.toJson(),
        'dominant_foot': dominantFoot?.toJson(),
        'position': position?.toJson(),
        'photo': photo,
        'parent_phone_number': parentPhoneNumber,
        'nik': nik,
        'performance': performanceTestVerification?.toJson(),
        'website': website,
        'club_player': clubPlayer?.toJson(),
        'overall_rating': overallRating,
      };

  Profile? toProfile() => Profile(
        id: id,
        name: name,
        address: address,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        city: city,
        parentPhoneNumber: parentPhoneNumber,
        nationality: nationality,
        nik: nik,
        photo: photo,
        dominantFoot: dominantFoot,
        height: height,
        weight: weight,
        isPlayer: true,
        website: website,
        playerPosition: position,
        clubPlayer: clubPlayer,
        gender: gender,
      );

  String gravatar() {
    var gravatar = Gravatar(name.toString());
    return gravatar.imageUrl(
        size: 150,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true);
  }

  String? get age {
    if (dateOfBirth == null) {
      return null;
    }
    return '${dateOfBirth?.formatAge()} tahun';
  }

  String? get ageCard {
    if (dateOfBirth == null) {
      return null;
    }
    return '${dateOfBirth?.formatAge()} Th.';
  }

  openWebsite() async {
    if (website != null) {
      if (await canLaunchUrlString(website!)) {
        await launchUrlString(website!);
      }
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        age,
        city,
        clubPlayer,
        dateOfBirth,
        dominantFoot,
        gender,
        height,
        nationality,
        nik,
        overallRating,
        parentPhoneNumber,
        performanceTestVerification,
        phoneNumber,
        photo,
        position,
        province,
        userId,
        website,
        weight,
      ];
}
