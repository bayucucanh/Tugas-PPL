import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:velocity_x/velocity_x.dart';

class Withdraw {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );
  String? id;
  User? user;
  String? name;
  String? accountNumber;
  String? bankName;
  String? bankCode;
  double? amount;
  String? notes;
  String? referenceNo;
  String? status;
  String? errorMessage;
  double? processedAmount;
  DateTime? createdAt;
  DateTime? updatedAt;

  Withdraw({
    this.id,
    this.accountNumber,
    this.amount,
    this.bankName,
    this.bankCode,
    this.createdAt,
    this.errorMessage,
    this.name,
    this.notes,
    this.processedAmount,
    this.referenceNo,
    this.status,
    this.updatedAt,
    this.user,
  });

  factory Withdraw.fromJson(Map<String, dynamic> json) => Withdraw(
        id: json['id'] as String?,
        accountNumber: json['account_number'] as String?,
        name: json['name'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        amount: json['amount'] == null
            ? null
            : double.parse(json['amount'].toString()),
        bankName: json['bank_name'] as String?,
        bankCode: json['bank_code'] as String?,
        errorMessage: json['error_message'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()).toLocal(),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'].toString()).toLocal(),
        notes: json['notes'] as String?,
        processedAmount: json['processed_amount'] == null
            ? null
            : double.parse(json['processed_amount'].toString()),
        referenceNo: json['reference_no'] as String?,
        status: json['status'] as String?,
      );

  String? get amountFormat {
    if (amount == null) {
      return null;
    }
    if (bankCode == 'gopay') {
      return _currencyFormatter.format((amount! - 1000).toStringAsFixed(0));
    }
    return _currencyFormatter.format((amount! - 5000).toStringAsFixed(0));
  }

  Color? get statusColor {
    switch (status) {
      case 'processed':
        return Vx.blue500;
      case 'failed':
      case 'rejected':
        return Vx.red500;
      case 'completed':
        return Vx.green500;
      case 'queued':
      default:
        return Vx.gray500;
    }
  }
}
