import 'package:do_it/src/screen/login/doit_login.dart';
import 'package:do_it/src/screen/profile/common/doit_profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_test/kakao_users/kakao_users.dart';

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
            DoitProfileMenu(
              title: 'Alert',
              children: <Widget>[
                Text("푸쉬 알림", style: menuTextStyle),
              ],
            ),
            DoitProfileMenu(
              title: 'Goal',
              children: <Widget>[
                Text("종료 된 Goal 보기", style: menuTextStyle),
              ],
            ),
            DoitProfileMenu(
              title: 'Feedback',
              children: <Widget>[
                Text("앱스토어 리뷰 남기기", style: menuTextStyle),
              ],
            ),
            DoitProfileMenu(
              title: 'Info',
              children: <Widget>[
                Text("버전 정보", style: menuTextStyle),
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
          onPressed: () async {
            final result = KakaoUsersRestAPI.logout();
            if (result == null) {
              print("Failed to logout kakao user");
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("카카오 계정 로그아웃에 실패하였습니다."),
                ),
              );
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => DoitLogin(),
                ),
                (predicate) => predicate == null,
              );
            }
          },
          color: Color(0xff2b2b2b),
        ),
      ],
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
TextStyle logoutTextStyle = const TextStyle(
  color: const Color(0xff777777),
  fontWeight: FontWeight.w400,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 14.0,
);
