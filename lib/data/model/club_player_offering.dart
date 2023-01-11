import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/offer_by.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_offering_position.dart';
import 'package:mobile_pssi/data/model/status.dart';

class ClubPlayerOffering {
  int? id;
  Club? clubReference;
  Club? club;
  Player? player;
  OfferBy? offerBy;
  Status? status;
  List<PlayerOfferingPosition>? offeringPositions;
  String? offerText;
  String? offerFile;
  String? replyFile;

  ClubPlayerOffering({
    this.id,
    this.clubReference,
    this.club,
    this.player,
    this.offerBy,
    this.status,
    this.offeringPositions,
    this.offerFile,
    this.offerText,
    this.replyFile,
  });

  factory ClubPlayerOffering.fromJson(Map<String, dynamic> json) {
    return ClubPlayerOffering(
      id: json['id'] as int?,
      clubReference: json['club_reference'] == null
          ? null
          : Club.fromJson(json['club_reference'] as Map<String, dynamic>),
      club: json['club'] == null
          ? null
          : Club.fromJson(json['club'] as Map<String, dynamic>),
      player: json['player'] == null
          ? null
          : Player.fromJson(json['player'] as Map<String, dynamic>),
      offerBy: json['offer_by'] == null
          ? null
          : OfferBy.fromJson(json['offer_by'] as Map<String, dynamic>),
      offeringPositions: (json['positions'] as List<dynamic>?)
          ?.map(
              (e) => PlayerOfferingPosition.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] == null
          ? null
          : json['status'] is Map
              ? Status.fromJson(json['status'] as Map<String, dynamic>)
              : null,
      offerText: json['offer_text'] as String?,
      offerFile: json['offer_file'] as String?,
      replyFile: json['reply_file'] as String?,
    );
  }

  Color get statusColor {
    Color defaultColor = Colors.grey;
    switch (status?.id) {
      case 1:
        defaultColor = Colors.blue;
        break;
      case 2:
        defaultColor = Colors.red;
        break;
      case 3:
        defaultColor = Colors.green;
        break;
    }
    return defaultColor;
  }
}
