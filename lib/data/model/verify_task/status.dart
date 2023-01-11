import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';

class Status {
  int? id;
  String? name;

  Status({this.id, this.name});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Color? getStatusColor() {
    Color defaultColor = pendingColor;
    switch (id) {
      case 2:
        defaultColor = primaryColor;
        break;
      case 3:
        defaultColor = deniedColor;
        break;
      case 1:
      default:
        defaultColor = pendingColor;
    }

    return defaultColor;
  }
}
