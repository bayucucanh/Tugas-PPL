import 'package:mobile_pssi/data/model/quick_reply_attachment.dart';

class QuickReply {
  String? id;
  String? shortcut;
  String? message;
  List<QuickReplyAttachment>? attachments;

  QuickReply({
    this.id,
    this.message,
    this.shortcut,
    this.attachments,
  });

  factory QuickReply.fromJson(Map<String, dynamic> json) => QuickReply(
      id: json['id'] as String?,
      message: json['message'] as String?,
      shortcut: json['shortcut'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => QuickReplyAttachment.fromJson(e as Map<String, dynamic>))
          .toList());
}
