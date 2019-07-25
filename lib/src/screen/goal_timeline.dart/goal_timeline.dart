import 'package:do_it/src/common_view/doit_bottom_widget.dart';
import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DoitTimeline extends StatelessWidget {
  DoitTimeline({
    @required this.goal,
  });
  final DoitGoalModel goal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: DoitFloatingActionButton(
        goal: goal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          DoitTimelineBackdrop(goal: goal),
          Align(
            alignment: Alignment.bottomCenter,
            child: DoitTimelineShootList(goal: goal),
          ),
        ],
      ),
    );
  }
}

class DoitTimelineShootList extends StatefulWidget {
  const DoitTimelineShootList({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  _DoitTimelineShootListState createState() => _DoitTimelineShootListState();
}

class _DoitTimelineShootListState extends State<DoitTimelineShootList> with SingleTickerProviderStateMixin {
  double height = 120.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (dragInfo) {
        double velocity = dragInfo.velocity.pixelsPerSecond.dy;
        if (velocity < 0) {
          setState(() {
            height = MediaQuery.of(context).size.height;
          });
        } else {
          setState(() {
            height = 120.0;
          });
        }
      },
      behavior: HitTestBehavior.deferToChild,
      child: SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: height,
          margin: EdgeInsets.only(top: 80),
          padding: EdgeInsets.only(top: 8.0, bottom: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(
                  10.0,
                )),
            color: Color(0xff222222),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  setState(() {
                    if (height == 120.0) {
                      height = MediaQuery.of(context).size.height;
                    } else {
                      height = 120.0;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 33.0),
                  child: Center(
                    child: Container(
                      width: 28.0,
                      height: 3.0,
                      decoration: BoxDecoration(
                        color: Color(0xffd8d8d8),
                        borderRadius: BorderRadius.circular(5.5),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class DoitTimelineBackdrop extends StatelessWidget {
  const DoitTimelineBackdrop({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      decoration: BoxDecoration(
        gradient: projectColors[getProjectColorIndex(goal.goalColor)],
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            DoitTimeLineAppBar(goal: goal),
            SizedBox(height: 30.0),
            DoitTimelineMainTitle(goal: goal),
            SizedBox(height: 30.0),
            DoitTimelineInfo(goal: goal),
            SizedBox(height: 20.0),
            Expanded(
              child: DoitTimelineRanking(
                goal: goal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoitTimelineInfo extends StatelessWidget {
  const DoitTimelineInfo({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "D - ${getDdayToEnd(goal)}",
                  style: titleBoldTextStyle,
                ),
                SizedBox(height: 8.0),
                Text(
                  "남은 기간",
                  style: descTextStyle.copyWith(
                    color: Colors.white.withOpacity(0.91),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.white.withOpacity(0.5),
            width: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  goal.penalty.toString(),
                  style: titleBoldTextStyle,
                ),
                SizedBox(height: 8.0),
                Text(
                  '전체 금액',
                  style: descTextStyle.copyWith(
                    color: Colors.white.withOpacity(0.91),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const TextStyle descTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontFamily: 'SpoqaHanSans',
  fontWeight: FontWeight.normal,
);

class DoitTimelineRanking extends StatefulWidget {
  const DoitTimelineRanking({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  _DoitTimelineRankingState createState() => _DoitTimelineRankingState();
}

class _DoitTimelineRankingState extends State<DoitTimelineRanking> {
  List<Widget> rankings;

  @override
  void initState() {
    super.initState();
    getMembersAndCreateRankingWidget();
  }

  getMembersAndCreateRankingWidget() async {
    List<DoitMember> members = await DoitGoalService.getMembers(widget.goal);
    members.sort((member1, member2) => (member2.progressRate - member1.progressRate));
    rankings = members.map((member) {
      final int index = members.indexOf(member);
      return DoitTimelineCard(index: index, member: member);
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 20.0),
      itemCount: rankings?.length ?? 0,
      itemBuilder: (context, index) => rankings[index],
      separatorBuilder: (context, index) => Divider(
        color: Colors.white.withOpacity(0.4),
        height: 1.0,
      ),
    );
  }
}

class DoitTimelineCard extends StatelessWidget {
  const DoitTimelineCard({
    Key key,
    @required this.index,
    @required this.member,
  }) : super(key: key);

  final int index;
  final DoitMember member;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (index < 3)
          Stack(
            children: <Widget>[
              Image.asset('assets/images/ic_medal_1.png'),
              Positioned(
                left: 7.0,
                top: 2.0,
                child: Text("${index + 1}"),
              ),
            ],
          ),
        if (index >= 3) SizedBox(width: 22.0),
        SizedBox(width: 12.0),
        SizedBox(
          height: 44.0,
          width: 44.0,
          child: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
        SizedBox(width: 14.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                member.name,
                style: descTextStyle.copyWith(
                  color: Colors.white.withOpacity(0.91),
                ),
              ),
              SizedBox(height: 6.0),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                animateFromLastPercent: true,
                lineHeight: 10.0,
                animation: true,
                animationDuration: 300,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Color(0xffffffff),
                backgroundColor: Colors.white.withOpacity(0.15),
                percent: member.progressRate / 100.0,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 14.0,
        ),
        Text(
          "${member.progressRate} %",
          style: descTextStyle.copyWith(fontSize: 20.0),
        ),
      ],
    );
  }
}

class DoitTimelineMainTitle extends StatelessWidget {
  const DoitTimelineMainTitle({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          goal.goalName,
          style: titleBoldTextStyle,
        ),
        SizedBox(height: 10.0),
        Text(
          getDateRange(goal),
          style: TextStyle(
            fontFamily: 'SpoqaHanSans',
            fontSize: 14.0,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

const TextStyle titleBoldTextStyle = TextStyle(
  fontFamily: 'SpoqaHanSans',
  fontSize: 30.0,
  fontWeight: FontWeight.w700,
);

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
