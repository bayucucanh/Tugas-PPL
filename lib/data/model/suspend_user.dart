import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/user.dart';

class SuspendUser {
  String? id;
  User? user;
  DateTime? expired;

  SuspendUser({this.id, this.expired, this.user});

  factory SuspendUser.fromJson(Map<String, dynamic> json) => SuspendUser(
        id: json['id'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        expired: json['expired'] == null
            ? null
            : DateTime.parse(json['expired'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user?.toJson(),
        'expired': expired?.toIso8601String(),
      };

  @override
  String toString() {
    if (expired == null) {
      return 'Akun ini telah di ban permanen.';
    } else {
      var df = DateFormat('EEEE, dd MMMM yyyy H:m:s a', 'id');
      return 'Akun ini telah di suspend hingga ${df.format(expired!)}';
    }
  }
}
