import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/screen/main/view/empty_goal_card.dart';
import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<MakeGoalModel> goals = [];

class DoitHome extends StatefulWidget {
  @override
  _DoitHomeState createState() => _DoitHomeState();
}

class _DoitHomeState extends State<DoitHome> {
  final GlobalKey mainScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    DoitGoalService.initialize();
  }

  @override
  void dispose() {
    DoitGoalService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainScaffoldKey,
      appBar: DoitMainAppBar(topPadding: 20.0),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: StreamBuilder<int>(
          stream: DoitGoalService.notifyStream.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              DoitGoalService.getGoalsFromServer(context);
              return Center(
                child: RefreshProgressIndicator(),
              );
            } else {
              DateTime now = DateTime.now();
              List<DoitGoalModel> inProgressGoals = DoitGoalService.goalList
                  .where(
                    (goal) => !isEnded(goal),
                  )
                  .toList();
              return Center(
                child: inProgressGoals.isEmpty
                    ? EmptyGoalCard()
                    : Container(
                        height: 404,
                        child: ListView.separated(
                          controller: PageController(
                            viewportFraction: (270.0 + 18.0) / MediaQuery.of(context).size.width,
                          ),
                          physics: PageScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: inProgressGoals.length + 1,
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 18.0);
                          },
                          itemBuilder: (context, index) {
                            if (index == inProgressGoals.length) return EmptyGoalCard();
                            return UserGoalCard(
                              goal: inProgressGoals[index],
                            );
                          },
                        ),
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DoitMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DoitMainAppBar({
    this.topPadding,
    Key key,
  }) : super(key: key);

  final double topPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 74.0, 30.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Do it",
            style: Theme.of(context).appBarTheme.textTheme.title.copyWith(fontSize: 30.0),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(110.0);
}
