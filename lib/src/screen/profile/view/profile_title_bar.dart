import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_it/src/screen/login/doit_login.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_test/kakao_users/kakao_users.dart';
import 'package:rest_api_test/model/user_info.dart';

class ProfileTitleBar extends StatefulWidget {
  const ProfileTitleBar({
    Key key,
  }) : super(key: key);

  @override
  _ProfileTitleBarState createState() => _ProfileTitleBarState();
}

class _ProfileTitleBarState extends State<ProfileTitleBar> {
  Future<KakaoUserInfo> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = KakaoUsersRestAPI.getUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KakaoUserInfo>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          KakaoUserInfo info;
          if (snapshot.hasData) {
            info = snapshot.data;
            print(info);
          }
          return Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                child: ClipOval(
                  child: (info?.thumbnailImageUrl != null)
                      ? Image(
                          image: CachedNetworkImageProvider(info.thumbnailImageUrl),
                        )
                      : Icon(Icons.person),
                ),
              ),
              SizedBox(width: 15.0),
              Text(
                info?.nickname ?? "로딩중...",
                style: TextStyle(
                  fontFamily: 'SpoqaHanSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  letterSpacing: 0.12,
                ),
              ),
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
        });
  }
}

TextStyle logoutTextStyle = const TextStyle(
  color: const Color(0xff777777),
  fontWeight: FontWeight.w400,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 14.0,
);
