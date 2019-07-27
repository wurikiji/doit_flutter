import 'package:do_it/src/screen/goal_timeline.dart/view/timeline_card.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:flutter/material.dart';

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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0),
        child: DoitTimelineCard(index: index, member: member),
      );
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
