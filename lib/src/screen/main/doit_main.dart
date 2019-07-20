import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/screen/main/view/empty_goal_card.dart';
import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<MakeGoalModel> goals = [];

class DoitHome extends StatelessWidget {
  final GlobalKey mainScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainScaffoldKey,
      appBar: DoitMainAppBar(topPadding: 20.0),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Consumer<GoalService>(
          builder: (context, value, child) {
            if (value == null) {
              print("No goal service");
              return child;
            } else {
              return StreamBuilder<DoitGoal>(
                stream: goalsInServer.stream,
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    print("snapshot data ${snapshot.data}");
                    goals.insert(0, snapshot.data.goal);
                  }
                  return Center(
                    child: inProgressGoal.isEmpty
                        ? EmptyGoalCard()
                        : Container(
                            height: 404,
                            child: ListView.separated(
                              controller: PageController(
                                viewportFraction: 270.0 / MediaQuery.of(context).size.width,
                              ),
                              physics: PageScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: inProgressGoal.length + 1,
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              separatorBuilder: (context, index) {
                                return SizedBox(width: 18.0);
                              },
                              itemBuilder: (context, index) {
                                if (index == inProgressGoal.length) return EmptyGoalCard();
                                return UserGoalCard(
                                  goal: inProgressGoal[index].goal,
                                );
                              },
                            ),
                          ),
                  );
                },
              );
            }
          },
          child: Center(
            child: EmptyGoalCard(),
          ),
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
          // GestureDetector(
          //   child: Image.asset(
          //     'assets/images/btn_goals_n.png',
          //   ),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(110.0);
}
