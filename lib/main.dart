import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/screen/main/doit_main.dart';
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
        textTheme: TextTheme(
          body1: const TextStyle(
            color: const Color.fromRGBO(0xff, 0xff, 0xff, 1.0),
            fontFamily: "SpoqaHanSans",
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
          ),
          title: const TextStyle(
            color: const Color(0xffffffff),
            fontWeight: FontWeight.bold,
            fontFamily: "SpoqaHanSans",
            fontStyle: FontStyle.normal,
            fontSize: 20.0,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30.0,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
            size: 30.0,
          ),
          brightness: Brightness.dark,
          textTheme: TextTheme(
            title: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.bold,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      home: DoitMainWidget(),
    );
  }
}
