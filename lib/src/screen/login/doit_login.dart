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
      if (userToken != null) {
        gotoDoitMain(context, userToken);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: FutureBuilder<KakaoUserToken>(
          future: loggedIn,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
              return DoitLoginScreen();
            } else {
              return DoitLoginScreen(isLoading: true);
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
    this.isLoading = false,
  }) : super(key: key);

  final bool isLoading;

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
                Container(
                  width: 120.0,
                  height: 50.0,
                  child: Image.asset(
                    'assets/images/img_logo.png',
                  ),
                ),
                SizedBox(height: 20.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '오늘 할 일을 미루지 말고, ',
                        style: const TextStyle(
                          color: Color(0xff9b9b9b),
                          fontWeight: FontWeight.w400,
                          fontFamily: "SpoqaHanSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                          letterSpacing: -0.2,
                        ),
                      ),
                      TextSpan(
                        text: '두잇',
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                          fontFamily: "SpoqaHanSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: RefreshProgressIndicator(),
            ),
          if (!isLoading)
            FlatButton(
              color: Color(0xff333333),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
              onPressed: () async {
                final KakaoUserToken token = await KakaoUsersRestAPI.login(context);
                if (token != null) {
                  gotoDoitMain(context, token);
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 62.0, vertical: 15.0),
              child: Text(
                "카카오톡으로 로그인 하기",
                style: const TextStyle(
                  color: Color(0xffdddddd),
                  fontWeight: FontWeight.w700,
                  fontFamily: "SpoqaHanSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
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
  await DoitUserAPI.registerTokenAndGetMid(token, firebaseMessaging);
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => DoitMain(),
    ),
  );
}
