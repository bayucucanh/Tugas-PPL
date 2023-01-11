import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/data/model/user.dart';

class Consultation extends Equatable {
  final int? id;
  final String? roomId;
  final Status? status;
  final User? createdBy;
  final User? consultWith;
  final Message? latestMessage;
  final DateTime? expired;
  final double? rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final _df = DateFormat('dd MMMM yyyy H:mm a', 'ID_id');

  Consultation({
    this.id,
    this.consultWith,
    this.createdAt,
    this.createdBy,
    this.roomId,
    this.status,
    this.updatedAt,
    this.latestMessage,
    this.expired,
    this.rating,
    this.comment,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
        id: json['id'] as int?,
        roomId: json['room_id'] as String?,
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
        latestMessage: json['latest_message'] == null
            ? null
            : Message.fromJson(json['latest_message'] as Map<String, dynamic>),
        consultWith: json['consult_with'] == null
            ? null
            : User.fromJson(json['consult_with'] as Map<String, dynamic>),
        createdBy: json['created_by'] == null
            ? null
            : User.fromJson(json['created_by'] as Map<String, dynamic>),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()).toLocal(),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'].toString()).toLocal(),
        rating: json['rating'] == null
            ? null
            : double.tryParse(json['rating'].toString()),
        comment: json['comment'] as String?,
        expired: json['expired'] == null
            ? null
            : DateTime.parse(json['expired'].toString()).toLocal());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'room_id': roomId,
        'status': status?.toJson(),
        'latest_message': latestMessage?.toJson(),
        'consult_with': consultWith?.toJson(),
        'expired': expired?.toIso8601String(),
        'rating': rating,
        'comment': comment,
        'created_by': createdBy?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  Duration? get expiredInMinute {
    if (expired == null) {
      return const Duration(minutes: 5);
    }
    DateTime now = DateTime.now();
    return expired?.difference(now);
  }

  String? get createdAtFormat =>
      createdAt == null ? null : _df.format(createdAt!);

  @override
  List<Object?> get props => [
        id,
        consultWith,
        createdBy,
        createdAt,
        status,
        roomId,
        updatedAt,
        latestMessage,
        rating,
        expired,
        comment,
      ];
}
