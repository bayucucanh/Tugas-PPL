import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/category.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/club_player.dart';
import 'package:mobile_pssi/data/model/dominant_foot.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/height.dart';
import 'package:mobile_pssi/data/model/nationality.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/weight.dart';
import 'package:mobile_pssi/extensions/age.extension.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

class Profile extends Equatable {
  final int? id;
  final String? name;
  final Gender? gender;
  final String? photo;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? parentPhoneNumber;
  final String? nik;
  final String? ktp;
  final Nationality? nationality;
  final String? address;
  final City? city;
  final Height? height;
  final Weight? weight;
  final DominantFoot? dominantFoot;
  final bool? isPlayer;
  final Club? club;
  final Category? category;
  final Province? province;
  final PlayerPosition? playerPosition;
  final String? website;
  final ClubPlayer? clubPlayer;

  const Profile({
    this.id,
    this.address,
    this.gender,
    this.city,
    this.parentPhoneNumber,
    this.dateOfBirth,
    this.dominantFoot,
    this.height,
    this.isPlayer,
    this.ktp,
    this.name,
    this.nationality,
    this.nik,
    this.phoneNumber,
    this.photo,
    this.weight,
    this.club,
    this.category,
    this.playerPosition,
    this.website,
    this.province,
    this.clubPlayer,
  });

  String? get age {
    return '$ageFormat tahun';
  }

  int? get ageFormat {
    if (dateOfBirth == null) {
      return null;
    }

    return dateOfBirth?.formatAge();
  }

  String gravatar() {
    var gravatar = Gravatar(name.toString());
    return gravatar.imageUrl(
        size: 150,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        gender,
        photo,
        dateOfBirth,
        phoneNumber,
        parentPhoneNumber,
        nik,
        ktp,
        nationality,
        address,
        city,
        height,
        website,
        height,
        dominantFoot,
        isPlayer,
        club,
        category,
        province,
        playerPosition,
        clubPlayer,
      ];
}
