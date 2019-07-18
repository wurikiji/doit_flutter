import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/common_view/doit_bottom_widget.dart';
import 'package:do_it/src/model/user_model.dart';
import 'package:do_it/src/screen/login/doit_login.dart';
import 'package:do_it/src/screen/main/doit_main.dart';
import 'package:do_it/src/screen/profile/doit_profile.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(DoIt());

class DoIt extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<GoalService>.value(
      value: GoalService(
        user: UserModel(),
      ),
      child: MaterialApp(
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
        // home: DoitMain(),
        home: DoitLogin(),
      ),
    );
  }
}

class DoitMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: DoitBottomAppBar(
          key: ValueKey('mainBottomAppBar'),
        ),
        floatingActionButton: DoitFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: TabBarView(
          children: <Widget>[
            DoitHome(),
            DoitProfile(),
          ],
        ),
      ),
    );
  }
}
