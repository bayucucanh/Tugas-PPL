import 'package:mobile_pssi/data/model/user.dart';

class BankAccount {
  int? id;
  User? user;
  String? name;
  String? alias;
  String? bankName;
  String? bankCode;
  String? accountNumber;

  BankAccount({
    this.id,
    this.name,
    this.accountNumber,
    this.alias,
    this.bankCode,
    this.bankName,
    this.user,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json['id'] as int?,
        accountNumber: json['account_number'] as String?,
        alias: json['alias'] as String?,
        bankCode: json['bank_code'] as String?,
        bankName: json['bank_name'] as String?,
        name: json['name'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );
}
