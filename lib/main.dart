import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/screen/make_goal/make_goal.dart';
import 'package:flutter/material.dart';

void main() => runApp(DoIt());

class DoIt extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: doitMainSwatch,
        backgroundColor: Color(doitPrimaryColorValue),
        scaffoldBackgroundColor: Color(doitPrimaryColorValue),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.bold,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
            body1: const TextStyle(
              color: const Color.fromRGBO(0xff, 0xff, 0xff, 0.4),
              fontWeight: FontWeight.w400,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
      home: TestHome(),
    );
  }
}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("앱 시작"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MakeGoal()),
            );
          },
        ),
      ),
    );
  }
}
