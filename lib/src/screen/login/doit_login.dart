import 'package:do_it/main.dart';
import 'package:flutter/material.dart';
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
    print("Init login view");
    loggedIn = KakaoUsersRestAPI.checkLogin();
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
        child: FutureBuilder(
          future: loggedIn,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                return DoitMain();
              } else {
                return DoitLoginScreen();
              }
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => DoitMain(),
                  ),
                );
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
