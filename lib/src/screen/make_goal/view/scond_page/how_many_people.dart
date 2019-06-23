import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HowManyPeople extends StatefulWidget {
  @override
  _HowManyPeopleState createState() => _HowManyPeopleState();
}

class _HowManyPeopleState extends State<HowManyPeople> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      title: "누구와 함께 할까요?",
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40.0,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Color(0xff2b2b2b),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      child: TextField(
                        controller: _textEditingController,
                        style: DoitMainTheme.makeGoalUserInputTextStyle,
                        maxLength: 2,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          counterText: "",
                        ),
                      ),
                    ),
                    Text(
                      '명',
                      style: DoitMainTheme.makeGoalUserInputTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Container(
              height: 40.0,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                color: Colors.white,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/noun_link_1880307.png',
                      height: 14.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      "초대 링크 복사",
                      style: TextStyle(
                        fontFamily: 'SpoqaHanSans',
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
