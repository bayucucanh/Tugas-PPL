import 'package:mobile_pssi/data/model/quick_reply.dart';

class QuickReplyAttachment {
  String? id;
  QuickReply? quickReply;
  String? file;
  String? extension;

  QuickReplyAttachment({this.id, this.extension, this.file, this.quickReply});

  factory QuickReplyAttachment.fromJson(Map<String, dynamic> json) =>
      QuickReplyAttachment(
        id: json['id'] as String?,
        quickReply: json['quick_reply'] == null
            ? null
            : QuickReply.fromJson(json['quick_reply'] as Map<String, dynamic>),
        file: json['file_url'] as String?,
        extension: json['extension'] as String?,
      );
}
