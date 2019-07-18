import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CardProgressIndicator extends StatelessWidget {
  const CardProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double diameter = min(constraints.maxWidth, constraints.maxHeight) - 10.0;
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          CircularPercentIndicator(
            radius: diameter,
            progressColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.white.withOpacity(0.15),
            lineWidth: 9.0,
            percent: 0.5,
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 500,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("hi"),
                Text("10%"),
              ],
            ),
          ),
        ],
      );
    });
  }
}
