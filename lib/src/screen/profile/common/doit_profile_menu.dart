import 'package:flutter/material.dart';
import 'package:rest_api_test/kakao_users/kakao_users.dart';

class DoitProfileMenu extends StatelessWidget {
  DoitProfileMenu({this.title, this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    print(KakaoUsersRestAPI.userToken == null);
    final int len = children.length - 1;
    for (int i = 0; i < len; i++) {
      print("Insert padding");
      children.insert(i * 2 + 1, SizedBox(height: 25.0));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProfileMenuCategory(
            title: title,
          ),
          SizedBox(height: 20.0),
          ...children,
        ],
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

TextStyle menuCategoryStyle = TextStyle(
  color: Color(0xffffffff).withOpacity(0.6),
  fontWeight: FontWeight.w700,
  fontFamily: "SpoqaHanSans",
  fontStyle: FontStyle.normal,
  fontSize: 14.0,
);
