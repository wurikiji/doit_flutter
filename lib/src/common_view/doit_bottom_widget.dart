import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/screen/shoot/doit_shoot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoitFloatingActionButton extends StatelessWidget {
  const DoitFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup(
          builder: (context) => DoitShoot(),
          context: context,
        );
      },
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
    );
  }
}

class DoitBottomAppBar extends StatelessWidget {
  const DoitBottomAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            DefaultTabController.of(context).animateTo(index);
          },
          tabs: <Widget>[
            Tab(
              child: Icon(
                Icons.home,
                color: Colors.white,
                size: 23.0,
              ),
            ),
            Tab(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 23.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
