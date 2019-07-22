import 'package:do_it/main.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_api_test/kakao_users/kakao_users.dart';

class DoitLogin extends StatefulWidget {
  @override
  _DoitLoginState createState() => _DoitLoginState();
}

class _DoitLoginState extends State<DoitLogin> {
  Future<KakaoUserToken> loggedIn;

  @override
  void initState() {
    super.initState();
    loggedIn = KakaoUsersRestAPI.checkLoginAndRefreshToken();
    loggedIn.then((userToken) async {
      gotoDoitMain(context, userToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(77, 144, 251, 1.0),
              Color.fromRGBO(119, 29, 228, 1.0),
            ],
          ),
        ),
        child: FutureBuilder<KakaoUserToken>(
          future: loggedIn,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
              return DoitLoginScreen();
            } else {
              return Center(
                child: RefreshProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class DoitLoginScreen extends StatelessWidget {
  const DoitLoginScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 90.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Do it',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontFamily: "SpoqaHanSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 36.0,
                  ),
                ),
                SizedBox(height: 40.0),
                Text(
                  '쿨 워터 향 폴폴폴 멘트~',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: "SpoqaHanSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
            onPressed: () async {
              final KakaoUserToken token = await KakaoUsersRestAPI.loginWithDifferentUser(context);
              if (token != null) {
                gotoDoitMain(context, token);
              }
            },
            padding: EdgeInsets.symmetric(horizontal: 62.0, vertical: 15.0),
            child: Text(
              "카카오톡으로 로그인 하기",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontFamily: "SpoqaHanSans",
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

gotoDoitMain(BuildContext context, KakaoUserToken token) async {
  final FirebaseMessaging firebaseMessaging = Provider.of<FirebaseMessaging>(context);
  print(await DoitUserAPI.registerTokenAndGetMid(token, firebaseMessaging));
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => DoitMain(),
    ),
  );
}
