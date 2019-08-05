import 'dart:async';

import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/common_view/doit_bottom_widget.dart';
import 'package:do_it/src/screen/first_splash/first_splash.dart';
import 'package:do_it/src/screen/main/doit_main.dart';
import 'package:do_it/src/screen/make_goal/view/second_page.dart';
import 'package:do_it/src/screen/profile/doit_profile.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
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

class DoIt extends StatefulWidget {
  @override
  _DoItState createState() => _DoItState();
}

class _DoItState extends State<DoIt> {
  @override
  void initState() {
    super.initState();
    initFirstDynamicLink();
  }

  initFirstDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deeplink = data?.link;
    if (deeplink != null) {
      List<String> path = deeplink.path.split('/');
      final int goalId = int.parse(path[3]);
      final int joinId = int.parse(path[5]);
      if (goalId != null && joinId != null) {
        var result = await DoitGoalService.joinGoal(goalId, joinId);
        if (result != null) {
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return SuccessModal(
                title: result.goalName,
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseMessaging>.value(
      value: _firebaseMessaging,
      child: MaterialApp(
        title: 'Doit',
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
        home: FirstSplashScreen(),
      ),
    );
  }
}

class DoitMain extends StatefulWidget {
  @override
  _DoitMainState createState() => _DoitMainState();
}

class _DoitMainState extends State<DoitMain> with WidgetsBindingObserver {
  Timer _linkTimer;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    getPermission();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkTimer?.cancel();
    print("Disposing this widget");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // initDynamicLinks();
    }
  }

  getPermission() async {
    var result = await PhotoManager.requestPermission();
    if (!result) {
      PhotoManager.openSetting();
    }
  }

  initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamiclink) async {
        final Uri link = dynamiclink.link;
        print(link);
        try {
          List<String> path = link.path.split('/');
          int goalId = int.parse(path[3]);
          int joinId = int.parse(path[5]);
          if (goalId != null && joinId != null) {
            var result = await DoitGoalService.joinGoal(goalId, joinId);
            if (result != null) {
              await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return SuccessModal(
                    title: result.goalName,
                  );
                },
              );
            } else {
              scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('Failed to join goal.'),
                ),
              );
            }
          }
        } catch (e) {
          print(e);
        }
      },
      onError: (OnLinkErrorException e) async {
        print(e.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
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
