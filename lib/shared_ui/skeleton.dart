import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double? radius;
  const Skeleton({
    Key? key,
    required this.width,
    required this.height,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ''
        .text
        .make()
        .skeleton(width: width, height: height)
        .cornerRadius(radius ?? 0);
  }
}
