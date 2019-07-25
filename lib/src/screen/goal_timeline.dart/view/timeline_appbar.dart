import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';

class DoitTimeLineAppBar extends StatelessWidget {
  const DoitTimeLineAppBar({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(-12.0, 0, 0),
            child: BackButton(),
          ),
          CardCategoryChip(goal: goal),
        ],
      ),
    );
  }
}
