import 'package:do_it/src/screen/login/doit_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SharedPreferences prefs = snapshot.data;
          bool welcomed = prefs.getBool('welcomed');
          return welcomed != null ? DoitLogin() : DoitWelcome();
        } else {
          return Scaffold(
            body: Center(
              child: Container(
                width: 120.0,
                height: 50.0,
                child: Image.asset('assets/images/img_logo.png'),
              ),
            ),
          );
        }
      },
    );
  }
}

class DoitWelcome extends StatelessWidget {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          Image.asset(
            'assets/images/splash/splash01.png',
            fit: BoxFit.fill,
          ),
          Image.asset(
            'assets/images/splash/splash02.png',
            fit: BoxFit.fill,
          ),
          Image.asset(
            'assets/images/splash/splash03.png',
            fit: BoxFit.fill,
          ),
          Image.asset(
            'assets/images/splash/splash04.png',
            fit: BoxFit.fill,
          ),
          Image.asset(
            'assets/images/splash/splash05.png',
            fit: BoxFit.fill,
          ),
          DoitLogin(),
        ],
        onPageChanged: (index) async {
          if (index == 5) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('welcomed', true);
            _controller.addListener(() {
              print(_controller.page);
              if (_controller.page < 5.0) {
                _controller.jumpToPage(5);
              }
            });
          }
        },
      ),
    );
  }
}
