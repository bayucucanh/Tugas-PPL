import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/extensions/tax.extension.dart';

class Event {
  final _df = DateFormat('dd MMMM yyyy');
  final _localizations = MaterialLocalizations.of(Get.context!);
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );

  int? id;
  String? eventType;
  String? type;
  String? name;
  String? target;
  String? description;
  String? banner;
  String? blurhash;
  bool? isOnline;
  String? meetingUrl;
  String? address;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? additionalDescriptionLabel;
  String? additionalDescription;
  String? speakerLabel;
  String? speaker;
  double? price;

  Event({
    this.id,
    this.eventType,
    this.address,
    this.target,
    this.banner,
    this.blurhash,
    this.description,
    this.additionalDescriptionLabel,
    this.additionalDescription,
    this.endDate,
    this.endTime,
    this.isOnline,
    this.meetingUrl,
    this.name,
    this.price,
    this.speaker,
    this.speakerLabel,
    this.startDate,
    this.startTime,
    this.type,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'] as int?,
        eventType: json['event_type'] as String?,
        target: json['target'] as String?,
        address: json['address'] as String?,
        banner: json['banner'] as String?,
        blurhash: json['blurhash'] as String?,
        description: json['description'] as String?,
        additionalDescriptionLabel:
            json['additional_description_label'] as String?,
        additionalDescription: json['additional_description'] as String?,
        isOnline: json['is_online'] == null
            ? null
            : json['is_online'] == 1
                ? true
                : false,
        meetingUrl: json['meeting_url'] as String?,
        name: json['name'] as String?,
        speaker: json['speaker'] as String?,
        speakerLabel: json['speaker_label'] as String?,
        type: json['type'] as String?,
        price: json['price'] == null
            ? null
            : double.parse(json['price'].toString()),
        startDate: json['start_date'] == null
            ? null
            : DateTime.parse(json['start_date'].toString()),
        endDate: json['end_date'] == null
            ? null
            : DateTime.parse(json['end_date'].toString()),
        startTime: json['start_time'] == null
            ? null
            : TimeOfDay(
                hour: int.parse(json['start_time']['hour'].toString()),
                minute: int.parse(json['start_time']['minute'].toString())),
        endTime: json['end_time'] == null
            ? null
            : TimeOfDay(
                hour: int.parse(json['end_time']['hour'].toString()),
                minute: int.parse(json['end_time']['minute'].toString())),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'event_type': eventType,
        'target': target,
        'name': name,
        'banner': banner,
        'blurhash': blurhash,
        'type': type,
        'address': address,
        'is_online': isOnline,
        'meeting_url': meetingUrl,
        'description': description,
        'additional_description_label': additionalDescriptionLabel,
        'additional_description': additionalDescription,
        'speaker_label': speakerLabel,
        'speaker': speaker,
        'start_date': startDate?.toString(),
        'end_date': endDate?.toString(),
        'start_time': startTime == null
            ? null
            : {
                'hour': startTime?.hour,
                'minute': startTime?.minute,
              },
        'end_time': endTime == null
            ? null
            : {
                'hour': endTime?.hour,
                'minute': endTime?.minute,
              },
        'price': price,
      };

  String? get startDateFormat =>
      startDate == null ? null : _df.format(startDate!);

  String? get endDateFormat => endDate == null ? null : _df.format(endDate!);

  String? get startTimeFormat => startTime == null
      ? null
      : _localizations.formatTimeOfDay(startTime!, alwaysUse24HourFormat: true);

  String? get endTimeFormat => endTime == null
      ? null
      : _localizations.formatTimeOfDay(endTime!, alwaysUse24HourFormat: true);

  String? get priceWithoutTaxFormat => price == null
      ? null
      : _currencyFormatter.format(price!.toStringAsFixed(0));

  String? get priceFormat => price == null
      ? null
      : _currencyFormatter.format(price!.addPriceTax()!.toStringAsFixed(0));
}
