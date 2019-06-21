import 'package:flutter/material.dart';

class DoitMainCard extends StatelessWidget {
  DoitMainCard({
    @required this.gradient,
    @required this.child,
  });
  final Gradient gradient;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        gradient: this.gradient,
        shadows: [
          BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 9.0,
            color: Color(0x1e000000),
          ),
        ],
      ),
      width: 270.0,
      height: 404.0,
      child: this.child,
    );
  }
}
