import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/common_view/doit_bottom_widget.dart';
import 'package:do_it/src/model/user_model.dart';
import 'package:do_it/src/screen/login/doit_login.dart';
import 'package:do_it/src/screen/main/doit_main.dart';
import 'package:do_it/src/screen/profile/doit_profile.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_api_test/kakao_users/kakao_users.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
const String clientId = 'ab8b947e7366f8cf7037d35eae899100';
void main() async {
  await KakaoUsersRestAPI.initialize(
    clientId: clientId,
    autoRefresh: true,
    refreshCallback: (userToken) async {
      if (userToken != null) {
        DoitUserAPI.registerTokenAndGetMid(userToken, _firebaseMessaging);
      }
    },
  );
  _firebaseMessaging.onTokenRefresh.listen((String token) async {
    if (KakaoUsersRestAPI.userToken != null) {
      DoitUserAPI.refreshFirebaseToken(token);
    }
  });
  runApp(DoIt());
}

class DoIt extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseMessaging>.value(
      value: _firebaseMessaging,
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
    return Provider<GoalService>.value(
      value: GoalService(
        user: UserModel(),
      ),
      child: DefaultTabController(
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
      ),
    );
  }
}
