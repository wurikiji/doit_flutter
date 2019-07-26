import 'package:do_it/src/screen/ended_goal/doit_ended_goals.dart';
import 'package:do_it/src/screen/profile/common/doit_profile_menu.dart';
import 'package:do_it/src/screen/profile/view/profile_title_bar.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DoitProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.0),
            Text(
              "My Page",
              style: myPageTextStyle,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ProfileTitleBar(),
                  DoitPushSetting(),
                  DoitShowFinshedGoals(),
                  DoitProfileMenu(
                    title: 'Feedback',
                    children: <Widget>[
                      Text("앱스토어 리뷰 남기기", style: menuTextStyle),
                    ],
                  ),
                  DoitProfileMenu(
                    title: 'Info',
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("버전 정보", style: menuTextStyle),
                          Spacer(),
                          DoitVersion(),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showLicensePage(
                            context: context,
                          );
                        },
                        child: Text("오픈소스 라이브러리", style: menuTextStyle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoitVersion extends StatelessWidget {
  final Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

  final TextStyle versionTextStyle = TextStyle(
    fontFamily: 'SpoqaHanSans',
    fontSize: 16.0,
    color: Colors.white.withOpacity(0.6),
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: packageInfo,
      builder: (context, snapshot) {
        String text = 'loading...';
        if (snapshot.hasData) {
          PackageInfo info = snapshot.data;
          String version = info.version;
          String buildNumber = info.buildNumber;
          text = '$version+$buildNumber';
        }
        return Text(
          text,
          style: versionTextStyle,
        );
      },
    );
  }
}

class DoitShowFinshedGoals extends StatelessWidget {
  const DoitShowFinshedGoals({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoitProfileMenu(
      title: 'Goal',
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DoitFinishedGoals(),
              ),
            );
          },
          child: Text("종료 된 Goal 보기", style: menuTextStyle),
        ),
      ],
    );
  }
}

class DoitPushSetting extends StatelessWidget {
  const DoitPushSetting({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoitProfileMenu(
      title: 'Alert',
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("푸쉬 알림", style: menuTextStyle),
            DoitPushButton(),
          ],
        ),
      ],
    );
  }
}

class DoitPushButton extends StatefulWidget {
  const DoitPushButton({
    Key key,
  }) : super(key: key);

  @override
  _DoitPushButtonState createState() => _DoitPushButtonState();
}

class _DoitPushButtonState extends State<DoitPushButton> {
  bool pushOn = false;

  @override
  void initState() {
    super.initState();
    _getPushInfo();
  }

  _getPushInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool pushInfo = prefs.getBool('pushOn');
    if (pushInfo ?? false) {
      setState(() {
        pushOn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          pushOn = !pushOn;
          prefs.setBool('pushOn', pushOn);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 31.0,
        width: 51.0,
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
          color: pushOn ? Color(0xff4d90fb) : Color(0xffdddddd),
        ),
        alignment: pushOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(1.5),
          child: Container(
            height: 28.0,
            width: 28.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(width: 0.5, color: Color(0x1a000000)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 1.0,
                  offset: Offset(0.0, 3.0),
                ),
                BoxShadow(
                  color: Color(0x28000000),
                  blurRadius: 1.0,
                  offset: Offset(0.0, 3.0),
                ),
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 1.0,
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle menuTextStyle = const TextStyle(
  color: const Color(0xffffffff),
  fontWeight: FontWeight.w400,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 16.0,
);

TextStyle myPageTextStyle = const TextStyle(
  color: const Color(0xffffffff),
  fontWeight: FontWeight.w700,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 30.0,
);
