import 'package:do_it/src/color/swatch.dart';
import 'package:flutter/material.dart';

class DoitFloatingActionButton extends StatelessWidget {
  const DoitFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          gradient: LinearGradient(
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
        child: Row(
          children: <Widget>[
            Expanded(
              child: Icon(
                Icons.home,
                color: Colors.white,
                size: 23.0,
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
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
