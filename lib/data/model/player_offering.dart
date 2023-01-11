import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/offer_by.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_offering_position.dart';
import 'package:mobile_pssi/data/model/status.dart';

class PlayerOffering {
  int? id;
  Club? club;
  Player? player;
  OfferBy? offerBy;
  Status? status;
  List<PlayerOfferingPosition>? offeringPositions;
  String? offerText;
  String? offerFile;

  PlayerOffering({
    this.id,
    this.club,
    this.player,
    this.offerBy,
    this.status,
    this.offeringPositions,
    this.offerFile,
    this.offerText,
  });

  factory PlayerOffering.fromJson(Map<String, dynamic> json) {
    return PlayerOffering(
      id: json['id'] as int?,
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
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'club': club?.toJson(),
        'player': player?.toJson(),
        'offer_by': offerBy?.toJson(),
        'positions': offeringPositions?.map((e) => e.toJson()).toList(),
        'status': status?.toJson(),
        'offer_text': offerText,
        'offer_file': offerFile,
      };

  Color get statusColor {
    Color defaultColor = Colors.grey;
    if (status?.id == 1) {
      defaultColor = Colors.green;
    } else if (status?.id == 2) {
      defaultColor = Colors.red;
    }
    return defaultColor;
  }
}
