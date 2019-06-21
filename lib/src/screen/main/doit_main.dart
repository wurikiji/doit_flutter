import 'package:do_it/src/common_view/doit_bottom_widget.dart';
import 'package:do_it/src/screen/main/view/empty_goal_card.dart';
import 'package:flutter/material.dart';

class DoitMainWidget extends StatelessWidget {
  final GlobalKey mainScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainScaffoldKey,
      appBar: DoitMainAppBar(topPadding: 20.0),
      bottomNavigationBar: DoitBottomAppBar(),
      floatingActionButton: DoitFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Center(
          child: EmptyGoalCard(),
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
            style: Theme.of(context)
                .appBarTheme
                .textTheme
                .title
                .copyWith(fontSize: 30.0),
          ),
          GestureDetector(
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 30.0,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(110.0);
}
