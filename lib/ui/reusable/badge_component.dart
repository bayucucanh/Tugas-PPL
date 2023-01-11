import 'package:flutter/material.dart';

class BadgeComponent extends StatelessWidget {
  final Widget child;
  final bool visible;
  final double width;
  const BadgeComponent(
      {Key? key, required this.child, this.visible = true, this.width = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        visible
            ? Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: width,
                    minHeight: width,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
