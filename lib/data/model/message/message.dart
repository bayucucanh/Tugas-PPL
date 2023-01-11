import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'receiver.dart';
import 'sender.dart';

class Message {
  String? id;
  String? title;
  String? message;
  String? imageUrl;
  Sender? sender;
  Receiver? receiver;
  dynamic data;
  DateTime? createdAt;
  String? type;
  String? morphId;
  DateTime? readAt;

  Message({
    this.id,
    this.title,
    this.message,
    this.imageUrl,
    this.sender,
    this.receiver,
    this.data,
    this.type,
    this.createdAt,
    this.readAt,
    this.morphId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String?,
      message: json['message'] as String?,
      sender: json['sender'] == null
          ? null
          : Sender.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: json['receiver'] == null
          ? null
          : Receiver.fromJson(json['receiver'] as Map<String, dynamic>),
      data: json['data'] as dynamic,
      type: json['type'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'].toString()).toLocal(),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'].toString()).toLocal(),
      morphId: json['morph_id'] as String?,
    );
  }

  factory Message.fromRemoteMessage(RemoteMessage message) => Message(
        id: message.messageId,
        title: message.notification?.title,
        data: message.data,
        message: message.notification?.body,
        imageUrl: GetPlatform.isAndroid
            ? message.notification?.android?.imageUrl
            : message.notification?.apple?.imageUrl,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'sender': sender?.toJson(),
        'receiver': receiver?.toJson(),
        'image_url': imageUrl,
        'data': data,
        'type': type,
        'created_at': createdAt,
        'read_at': readAt,
        'morph_id': morphId,
      };

  bool? isSender(User currentUser) => sender?.userId == currentUser.id;

  String get formatHourOnly => DateFormat('Hm').format(createdAt!);

  openLink(String? url) async {
    if (url != null) {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    }
  }
}
