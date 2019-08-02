import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/screen/shoot/doit_shoot.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoitFloatingActionButton extends StatelessWidget {
  const DoitFloatingActionButton({
    Key key,
    this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    bool clicked = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () async {
            await showCupertinoModalPopup(
              builder: (context) => DoitShoot(
                goal: goal,
              ),
              context: context,
            );
          },
          onTapDown: (_) {
            setState(() {
              clicked = true;
            });
          },
          onTapCancel: () {
            setState(() {
              clicked = false;
            });
          },
          onTapUp: (_) {
            setState(() {
              clicked = false;
            });
          },
          child: AnimatedOpacity(
            opacity: clicked ? 0.6 : 1.0,
            duration: Duration(milliseconds: 100),
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff4d90fb),
                    Color(0xff771de4),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 36.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DoitBottomAppBar extends StatelessWidget {
  const DoitBottomAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool homeClicked = false;
    bool profileClicked = false;
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 65.0,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xff282828),
              width: 1.0,
            ),
          ),
          color: doitMainSwatch,
        ),
        child: TabBar(
          onTap: (int index) {
            print('tapped tabbar');
            DefaultTabController.of(context).animateTo(index);
          },
          tabs: <Widget>[
            Tab(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print("Tapped tab 1");
                      DefaultTabController.of(context).animateTo(0);
                    },
                    onTapDown: (_) {
                      setState(() {
                        homeClicked = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        homeClicked = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        homeClicked = false;
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: homeClicked ? 0.6 : 1.0,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 23.0,
                      ),
                    ),
                  );
                },
              ),
            ),
            Tab(
              child: StatefulBuilder(builder: (context, setState) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    print("Tapped tab 1");
                    DefaultTabController.of(context).animateTo(1);
                  },
                  onTapDown: (_) {
                    setState(() {
                      profileClicked = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      profileClicked = false;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      profileClicked = false;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: profileClicked ? 0.6 : 1.0,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 23.0,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
