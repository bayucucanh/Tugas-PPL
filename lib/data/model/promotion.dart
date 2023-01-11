import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/new_student_form.dart';
import 'package:mobile_pssi/data/model/selection_form.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/utils/timeago/id_locale.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;

class Promotion {
  final _dt = DateFormat('EEEE, dd MMM yyyy | HH:mm', 'id');
  int? id;
  Club? club;
  String? target;
  int? promoType;
  NewStudentForm? newStudentForm;
  SelectionForm? selectionForm;
  Status? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Promotion({
    this.club,
    this.id,
    this.newStudentForm,
    this.selectionForm,
    this.status,
    this.promoType,
    this.target,
    this.createdAt,
    this.updatedAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json['id'] as int?,
        club: json['club'] == null
            ? null
            : Club.fromJson(json['club'] as Map<String, dynamic>),
        promoType: json['promo_type'] as int?,
        newStudentForm: json['new_student_form'] == null
            ? null
            : NewStudentForm.fromJson(
                json['new_student_form'] as Map<String, dynamic>),
        selectionForm: json['selection_form'] == null
            ? null
            : SelectionForm.fromJson(
                json['selection_form'] as Map<String, dynamic>),
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
        target: json['target'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()).toLocal(),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'].toString()).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'club': club?.toJson(),
        'promo_type': promoType,
        'new_student_form': newStudentForm?.toJson(),
        'selection_form': selectionForm?.toJson(),
        'status': status?.toJson(),
        'target': target,
      };

  String get promoLabel => promoType == 1 ? 'Siswa Baru' : 'Seleksi';

  String? get formatCreatedAt =>
      createdAt == null ? null : _dt.format(createdAt!);

  String? get elapsedTimeSinceCreated {
    timeago.setLocaleMessages('id', IdMessages());
    return createdAt == null ? null : timeago.format(createdAt!, locale: 'id');
  }
}
