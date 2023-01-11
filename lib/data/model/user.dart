import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/consultation_classification_user.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/secure_document.dart';
import 'package:mobile_pssi/data/model/specialist.dart';
import 'package:mobile_pssi/data/model/subscribe_receipt.dart';
import 'package:mobile_pssi/data/model/suspend_user.dart';
import 'package:mobile_pssi/utils/timeago/id_locale.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;

import 'employee.dart';
import 'player.dart';
import 'role.dart';

class User extends Equatable {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );
  final int? id;
  final bool? isOnline;
  final String? email;
  final String? phoneNumber;
  final Employee? employee;
  final Player? player;
  final Club? club;
  final String? username;
  final int? userType;
  final List<Role>? roles;
  final String? googleId;
  final String? fbId;
  final String? appleId;
  final SubscribeReceipt? subscribeReceipt;
  final List<SecureDocument>? secureDocuments;
  final List<SecureDocument>? partnerDocuments;
  final ConsultationClassificationUser? classificationUser;
  final List<Specialist>? specialists;
  final SuspendUser? suspendUser;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? balance;

  User({
    this.id,
    this.isOnline,
    this.email,
    this.phoneNumber,
    this.employee,
    this.player,
    this.club,
    this.username,
    this.roles,
    this.userType,
    this.googleId,
    this.fbId,
    this.appleId,
    this.suspendUser,
    this.subscribeReceipt,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.secureDocuments,
    this.partnerDocuments,
    this.classificationUser,
    this.specialists,
    this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      isOnline: json['is_online'] == null ? false : json['is_online'] as bool?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      employee: json['employee'] == null
          ? null
          : Employee.fromJson(json['employee'] as Map<String, dynamic>),
      player: json['player'] == null
          ? null
          : Player.fromJson(json['player'] as Map<String, dynamic>),
      club: json['club'] == null
          ? null
          : Club.fromJson(json['club'] as Map<String, dynamic>),
      username: json['username'] as String?,
      roles: json['roles'] == [] || json['roles'] == null
          ? []
          : (json['roles'] as List).map((e) => Role.fromJson(e)).toList(),
      userType: json['user_type'] as int?,
      googleId: json['google_id'] as String?,
      fbId: json['fb_id'] as String?,
      secureDocuments:
          json['secure_documents'] == [] || json['secure_documents'] == null
              ? []
              : (json['secure_documents'] as List)
                  .map((e) => SecureDocument.fromJson(e))
                  .toList(),
      partnerDocuments:
          json['partner_documents'] == [] || json['partner_documents'] == null
              ? []
              : (json['partner_documents'] as List)
                  .map((e) => SecureDocument.fromJson(e))
                  .toList(),
      subscribeReceipt: json['subscription'] == null
          ? null
          : SubscribeReceipt.fromJson(
              json['subscription'] as Map<String, dynamic>),
      classificationUser: json['classification_user'] == null
          ? null
          : ConsultationClassificationUser.fromJson(
              json['classification_user'] as Map<String, dynamic>),
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      suspendUser: json['suspend_user'] == null
          ? null
          : SuspendUser.fromJson(json['suspend_user'] as Map<String, dynamic>),
      specialists:
          json['coach_specialists'] == [] || json['coach_specialists'] == null
              ? []
              : (json['coach_specialists'] as List)
                  .map((e) => Specialist.fromJson(e))
                  .toList(),
      balance: json['wallet'] == null
          ? null
          : double.parse(json['wallet'].toString()),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_online': isOnline,
        'email': email,
        'phone_number': phoneNumber,
        'employee': employee?.toJson(),
        'player': player?.toJson(),
        'club': club?.toJson(),
        'username': username,
        'roles': roles?.map((e) => e.toJson()).toList(),
        'user_type': userType,
        'google_id': googleId,
        'fb_id': fbId,
        'apple_id': appleId,
        'partner_documents': partnerDocuments?.map((e) => e.toJson()).toList(),
        'secure_documents': secureDocuments?.map((e) => e.toJson()).toList(),
        'subscription': subscribeReceipt?.toJson(),
        'classification_user': classificationUser?.toJson(),
        'coach_specialists': specialists?.map((e) => e.toJson()).toList(),
        'suspend_user': suspendUser?.toJson(),
        'email_verified_at': emailVerifiedAt?.toString(),
        'wallet': balance,
        'created_at': createdAt?.toString(),
        'updated_at': updatedAt?.toString(),
      };

  bool hasRoles(List<String> roleName) {
    return roles!.isNotEmpty
        ? roles!.any((role) => roleName
            .any((filter) => filter.toLowerCase() == role.slug!.toLowerCase()))
        : false;
  }

  bool hasRole(String roleName) {
    return roles == null
        ? false
        : roles!.isNotEmpty
            ? roles!.any((role) =>
                role.name!.toLowerCase().contains(roleName.toLowerCase()))
            : false;
  }

  String get imageProfile {
    if (profile == null) {
      return gravatar();
    } else if (profile?.photo == null) {
      return gravatar();
    } else {
      return profile?.photo == null ? gravatar() : profile!.photo!;
    }
  }

  String gravatar() {
    var gravatar = Gravatar(email.toString());
    return gravatar.imageUrl(
        size: 150,
        defaultImage: GravatarImage.retro,
        rating: GravatarRating.pg,
        fileExtension: true);
  }

  bool get isCoach => roles != null
      ? roles!.isNotEmpty
          ? roles!.any((role) => role.id == 3)
          : false
      : false;

  bool get isPlayer => player == null ? false : true;

  bool get isClub => club == null ? false : true;

  bool get hasMultiRole => roles != null
      ? roles!.length >= 2
          ? true
          : false
      : false;

  bool get hasOneRole => roles != null
      ? roles!.length == 1
          ? true
          : false
      : false;

  Profile? get profile {
    if (isPlayer) {
      return player?.toProfile();
    } else if (isClub) {
      return club?.toProfile();
    }
    return employee?.toProfile();
  }

  SecureDocument? getSingleDocument({required String slug}) {
    if (secureDocuments == null || secureDocuments!.isEmpty) {
      return null;
    }
    return secureDocuments?.firstWhere((document) => document.slug == slug,
        orElse: () => SecureDocument());
  }

  SecureDocument? get birthCertificate =>
      secureDocuments == null || secureDocuments!.isEmpty
          ? null
          : secureDocuments?.firstWhere(
              (document) => document.slug == 'akta-kelahiran',
              orElse: () => SecureDocument());

  SecureDocument? get ktp => secureDocuments == null || secureDocuments!.isEmpty
      ? null
      : secureDocuments?.firstWhere((document) => document.slug == 'ktp',
          orElse: () => SecureDocument());

  SecureDocument? get parentKtp =>
      secureDocuments == null || secureDocuments!.isEmpty
          ? null
          : secureDocuments?.firstWhere(
              (document) => document.slug == 'ktp-orang-tua',
              orElse: () => SecureDocument());

  SecureDocument? get kkDocument =>
      secureDocuments == null || secureDocuments!.isEmpty
          ? null
          : secureDocuments?.firstWhere(
              (document) => document.slug == 'kartu-keluarga',
              orElse: () => SecureDocument());

  SecureDocument? get ijazah =>
      secureDocuments == null || secureDocuments!.isEmpty
          ? null
          : secureDocuments?.firstWhere((document) => document.slug == 'ijazah',
              orElse: () => SecureDocument());

  SecureDocument? get raport =>
      secureDocuments == null || secureDocuments!.isEmpty
          ? null
          : secureDocuments?.firstWhere((document) => document.slug == 'raport',
              orElse: () => SecureDocument());

  SecureDocument? get klb => secureDocuments == null || secureDocuments!.isEmpty
      ? null
      : secureDocuments?.firstWhere(
          (document) => document.slug == 'klb-dokumen',
          orElse: () => SecureDocument());

  String? get createdTimeAgo {
    timeago.setLocaleMessages('id', IdMessages());
    return createdAt == null ? null : timeago.format(createdAt!, locale: 'id');
  }

  String? get balanceFormat {
    return balance == null
        ? null
        : _currencyFormatter.format(balance!.toStringAsFixed(0));
  }

  @override
  List<Object?> get props => [
        id,
        appleId,
        balance,
        classificationUser,
        club,
        createdAt,
        email,
        emailVerifiedAt,
        employee,
        fbId,
        googleId,
        isOnline,
        partnerDocuments,
        phoneNumber,
        player,
        roles,
        specialists,
        suspendUser,
        subscribeReceipt,
        secureDocuments,
        username,
        userType,
      ];
}
