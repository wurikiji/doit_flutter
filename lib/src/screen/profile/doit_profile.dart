import 'package:flutter/material.dart';

class DoitProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            Text(
              "My Page",
              style: myPageTextStyle,
            ),
            SizedBox(height: 30.0),
            ProfileTitleBar(),
            SizedBox(height: 35.0),
            PushAlertSetting(),
            ProfileMenuCategory(title: 'Goal'),
            SizedBox(height: 20.0),
            Text("종료 된 Goal 보기", style: menuTextStyle),
            ProfileMenuCategory(title: 'Feedback'),
            SizedBox(height: 20.0),
            Text("앱스토어 리뷰 남기기", style: menuTextStyle),
            SizedBox(height: 35.0),
            ProfileMenuCategory(title: 'App'),
            SizedBox(height: 20.0),
            Text("버전 정보", style: menuTextStyle),
            SizedBox(height: 25.0),
            Text("오픈소스 라이브러리", style: menuTextStyle),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuCategory extends StatelessWidget {
  const ProfileMenuCategory({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: menuCategoryStyle,
    );
  }
}

class PushAlertSetting extends StatelessWidget {
  const PushAlertSetting({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ProfileMenuCategory(title: 'Alert'),
        SizedBox(height: 20.0),
        Row(
          children: <Widget>[
            Text(
              "푸쉬 알림",
              style: menuTextStyle,
            ),
          ],
        ),
        SizedBox(height: 35.0),
      ],
    );
  }
}

class ProfileTitleBar extends StatelessWidget {
  const ProfileTitleBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          child: Icon(Icons.person),
        ),
        SizedBox(width: 15.0),
        Text("taesong.lee"),
        Spacer(),
        FlatButton(
          child: Text(
            "로그아웃",
            style: logoutTextStyle,
          ),
          shape: StadiumBorder(),
          onPressed: () {},
          color: Color(0xff2b2b2b),
        ),
      ],
    );
  }
}

TextStyle menuCategoryStyle = TextStyle(
  color: Color(0xffffffff).withOpacity(0.6),
  fontWeight: FontWeight.w700,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 14.0,
);

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
TextStyle logoutTextStyle = const TextStyle(
  color: const Color(0xff777777),
  fontWeight: FontWeight.w400,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 14.0,
);
