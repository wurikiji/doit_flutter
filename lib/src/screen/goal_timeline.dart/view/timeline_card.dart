import 'package:do_it/src/screen/goal_timeline.dart/goal_timeline.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
                percent: member.progressRate / 100.0 > 1.0 ? 1.0 : member.progressRate / 100.0,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 14.0,
        ),
        Text(
          "${member.progressRate / 100.0 > 1.0 ? 100 : member.progressRate} %",
          style: descTextStyle.copyWith(fontSize: 20.0),
        ),
      ],
    );
  }
}
