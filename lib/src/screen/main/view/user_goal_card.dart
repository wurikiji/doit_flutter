import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/main/common/goal_card.dart';
import 'package:do_it/src/screen/main/view/card_progress_indicator.dart';
import 'package:do_it/src/screen/make_goal/make_goal.dart';
import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/service/api/category_service.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const buttonColors = <Color>[
  Color(0xfff63b7c),
  Color(0xfff27539),
  Color(0xff38b544),
  Color(0xff11c2bf),
  Color(0xff1d91f4),
  Color(0xff2583e4),
  Color(0xff7031e8),
  Color(0xffab20d0),
];

class UserGoalCard extends StatelessWidget {
  const UserGoalCard({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: DoitMainCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardTitleBar(goal: goal),
              CardGoalPeriod(goal: goal),
              SizedBox(height: 10.0),
              CardCategoryChip(goal: goal),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10.0,
                    bottom: 25.0,
                    top: 15.0,
                  ),
                  child: CardProgressIndicator(
                    goal: goal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CardInvitationButton(goal: goal),
              ),
            ],
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: projectColors[getProjectColorIndex(goal.goalColor)].colors,
        ),
      ),
    );
  }
}

class CardCategoryChip extends StatelessWidget {
  const CardCategoryChip({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: Color(0x26222222),
      ),
      child: IntrinsicWidth(
        child: Text(
          goal.categoryName,
          style: TextStyle(
            fontFamily: 'SpoqaHanSans',
            fontSize: 10.0,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CardGoalPeriod extends StatelessWidget {
  const CardGoalPeriod({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(DateFormat('yyyy-MM-dd').format(goal.startDate)),
        Text(" ~ "),
        Text(DateFormat('yyyy-MM-dd').format(goal.endDate)),
      ],
    );
  }
}

// 친구 초대 버튼
class CardInvitationButton extends StatelessWidget {
  const CardInvitationButton({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {},
      shape: StadiumBorder(),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.person_add,
            color: buttonColors[getProjectColorIndex(goal.goalColor)],
          ),
          SizedBox(width: 4.0),
          Text(
            "같이 할 친구 초대하기",
            style: TextStyle(
              fontFamily: "SpoqaHanSans",
              color: buttonColors[getProjectColorIndex(goal.goalColor)],
            ),
          ),
        ],
      ),
    );
  }
}

int getProjectColorIndex(String stringColors) {
  List<String> stringColorList = stringColors.split(RegExp(':')).toList();
  List<Color> colorList = stringColorList.map((color) {
    String refine = color.substring(1);
    int colorInt = int.parse(refine, radix: 16);
    return Color(colorInt | 0xff000000);
  }).toList();
  for (var gradient in projectColors) {
    int count = 0;
    for (var pcolor in gradient.colors) {
      for (var color in colorList) {
        if (pcolor == color) count++;
      }
    }
    if (count >= 2) return projectColors.indexOf(gradient);
  }
  return 0;
}

class CardTitleBar extends StatelessWidget {
  const CardTitleBar({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          goal.goalName,
          style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(fontSize: 24.0),
        ),
        GestureDetector(
          child: Image.asset('assets/images/btn_more_n.png'),
          onTap: () async {
            await showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text("친구 초대 링크 보내기"),
                    onPressed: () {},
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {},
                    child: Text("Goal 나가기"),
                    isDestructiveAction: true,
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("취소"),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
