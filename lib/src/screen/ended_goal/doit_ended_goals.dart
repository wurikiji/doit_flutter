import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DoitFinishedGoals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DoitGoalModel> finishedGoals = DoitGoalService.goalList
        .where(
          (goal) => isEnded(goal),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("종료된 Goal"),
        elevation: 0.0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 40.0,
        ),
        separatorBuilder: (context, index) {
          return SizedBox(height: 16.0);
        },
        itemCount: finishedGoals.length,
        itemBuilder: (context, index) {
          return DoitFinishedGoalCard(
            goal: finishedGoals[index],
          );
        },
      ),
    );
  }
}

class DoitFinishedGoalCard extends StatelessWidget {
  const DoitFinishedGoalCard({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 316.0,
        height: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: const Color(0xff333333),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 9.0,
              color: Color(0x1e000000),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DoitFinishedGoalCardTitleBar(goal: goal),
            SizedBox(height: 4.0),
            DoitFinishedGoalCardPeriod(goal: goal),
            Spacer(),
            DoitFinishedGoalProgress(goal: goal),
          ],
        ),
      ),
    );
  }
}

class DoitFinishedGoalProgress extends StatelessWidget {
  const DoitFinishedGoalProgress({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 155.5,
          child: LinearPercentIndicator(
            padding: EdgeInsets.zero,
            animateFromLastPercent: true,
            lineHeight: 6.0,
            animation: true,
            animationDuration: 300,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Color(0xffccccc0),
            backgroundColor: Color(0x33ffffff),
            percent: goal.progressRate / 100,
          ),
        ),
        SizedBox(width: 12.5),
        Text(
          '${goal.progressRate}% 달성',
          style: TextStyle(
            fontFamily: 'SpoqaHanSans',
            fontSize: 12.0,
            letterSpacing: 0.09,
            color: Color(0xffccccc0),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 6.0),
          child: CardCategoryChip(
            goal: goal,
          ),
        ),
      ],
    );
  }
}

class DoitFinishedGoalCardTitleBar extends StatelessWidget {
  const DoitFinishedGoalCardTitleBar({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          goal.goalName,
          style: const TextStyle(
            color: const Color(0xffccccc0),
            fontWeight: FontWeight.w700,
            fontFamily: "SpoqaHanSans",
            fontStyle: FontStyle.normal,
            fontSize: 24.0,
          ),
        ),
        GestureDetector(
          child: Image.asset('assets/images/btn_more_n.png'),
          onTap: () {},
        ),
      ],
    );
  }
}

class DoitFinishedGoalCardPeriod extends StatelessWidget {
  const DoitFinishedGoalCardPeriod({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          DateFormat('yyyy-MM-dd').format(goal.startDate),
          style: periodTextStyle,
        ),
        Text(" ~ "),
        Text(
          DateFormat('yyyy-MM-dd').format(goal.endDate),
          style: periodTextStyle,
        ),
      ],
    );
  }
}

const TextStyle periodTextStyle = const TextStyle(
  color: const Color(0xffccccc0),
  fontWeight: FontWeight.normal,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 14.0,
);
