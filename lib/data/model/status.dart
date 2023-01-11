import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class Status extends Equatable {
  final int? id;
  final String? name;

  const Status({this.id, this.name});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

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

  Color statusColor() {
    Color color;
    switch (id) {
      case 1:
        color = Colors.green;
        break;
      case 2:
        color = Colors.amber;
        break;
      case 3:
        color = Colors.red;
        break;
      case 4:
        color = Colors.amberAccent;
        break;
      case 0:
      default:
        color = Colors.grey;
    }
    return color;
  }

  Color paymentStatusColor() {
    Color color;
    switch (id) {
      case 1:
        color = Vx.gray500;
        break;
      case 2:
        color = Vx.green500;
        break;
      case 3:
        color = Colors.red;
        break;
      case 4:
        color = Colors.amberAccent;
        break;
      case 0:
      default:
        color = Colors.grey;
    }
    return color;
  }

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
