import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';

class DoitShootTimer extends StatelessWidget {
  DoitShootTimer({
    @required this.goal,
  });
  final DoitGoalModel goal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: projectColors[getProjectColorIndex(goal.goalColor)],
        ),
        padding: EdgeInsets.only(bottom: 46.0, left: 20.0, right: 20.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DoitTimerAppBar(),
              SizedBox(height: 80.0),
              DoitTimerTimes(),
              SizedBox(height: 60.0),
              DoitTimerStartButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class DoitTimerTimes extends StatelessWidget {
  const DoitTimerTimes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListWheelScrollView(
            physics: FixedExtentScrollPhysics(),
            children: <Widget>[
              DoitTimersTimeText(title: '10'),
              DoitTimersTimeText(title: '20'),
              DoitTimersTimeText(title: '30'),
              DoitTimersTimeText(title: '60'),
              DoitTimersTimeText(title: '120'),
            ],
            itemExtent: 92.0,
          ),
          Align(
            alignment: Alignment.center.add(Alignment(0.5, 0)),
            child: Text("min", style: minTextStyle),
          ),
        ],
      ),
    );
  }
}

class DoitTimersTimeText extends StatelessWidget {
  const DoitTimersTimeText({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: timeTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

const TextStyle minTextStyle = TextStyle(
  fontFamily: 'SpoqaHanSans',
  fontSize: 20.0,
  letterSpacing: 2.14,
  color: Colors.white,
);

const TextStyle timeTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 44.0,
  letterSpacing: 4.71,
  color: Colors.white,
);

class DoitTimerAppBar extends StatelessWidget {
  const DoitTimerAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Image.asset('assets/images/backButton.png'),
      ),
      centerTitle: true,
      title: Text("Time"),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}

class DoitTimerStartButton extends StatelessWidget {
  const DoitTimerStartButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      height: 50.0,
      child: FlatButton(
        onPressed: () {},
        color: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Text(
          "시작",
          style: TextStyle(
            fontFamily: 'SpoqaHanSans',
            fontSize: 16.0,
            letterSpacing: 1.71,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
