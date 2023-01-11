import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/data/model/promotion.dart';
import 'package:mobile_pssi/data/model/player.dart';

class SelectionForm {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );
  final _if = DateFormat('yyyy-MM-dd');
  final _df = DateFormat('EEEE, dd MMMM yyyy', 'id');
  final _tif = DateFormat('HH:mm:ss');
  final _tf = DateFormat('HH:mm');

  int? id;
  Promotion? promotion;
  String? location;
  String? address;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? birthYears;
  String? competition;
  int? passQuota;
  double? selectionFee;
  String? notes;
  double? fee;
  int? formQuota;
  List<Player>? players;

  SelectionForm({
    this.address,
    this.promotion,
    this.birthYears,
    this.competition,
    this.endDate,
    this.endTime,
    this.fee,
    this.formQuota,
    this.id,
    this.location,
    this.notes,
    this.passQuota,
    this.selectionFee,
    this.startDate,
    this.startTime,
    this.players,
  });

  factory SelectionForm.fromJson(Map<String, dynamic> json) => SelectionForm(
        id: json['id'] as int?,
        address: json['address'] as String?,
        birthYears: json['birth_years'] as String?,
        competition: json['competition'] as String?,
        endDate: json['end_date'] as String?,
        startDate: json['start_date'] as String?,
        endTime: json['end_time'] as String?,
        startTime: json['start_time'] as String?,
        fee: json['fee'] == null
            ? null
            : double.tryParse(json['fee'].toString()),
        formQuota: json['form_quota'] as int?,
        location: json['location'] as String?,
        notes: json['notes'] as String?,
        passQuota: json['pass_quota'] as int?,
        promotion: json['promotion'] == null
            ? null
            : Promotion.fromJson(json['promotion'] as Map<String, dynamic>),
        selectionFee: json['selection_fee'] == null
            ? null
            : double.tryParse(json['selection_fee'].toString()),
        players: (json['players'] as List<dynamic>?)
            ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'location': location,
        'promotion': promotion?.toJson(),
        'birth_years': birthYears,
        'competition': competition,
        'pass_quota': passQuota,
        'start_date': startDate,
        'end_date': endDate,
        'start_time': startTime,
        'end_time': endTime,
        'selection_fee': selectionFee,
        'fee': fee,
        'notes': notes,
        'form_quota': formQuota,
      };

  String? get feePrice =>
      fee == null ? null : _currencyFormatter.format(fee.toString());

  String? get selectionFeePrice => selectionFee == null
      ? null
      : _currencyFormatter.format(selectionFee.toString());

  String? get formatStartDate =>
      startDate == null ? null : _df.format(_if.parse(startDate!));
  String? get formatEndDate =>
      endDate == null ? null : _df.format(_if.parse(endDate!));

  String? get startTimeFormat =>
      startTime == null ? null : _tf.format(_tif.parse(startTime!));
  String? get endTimeFormat =>
      endTime == null ? null : _tf.format(_tif.parse(endTime!));
}
