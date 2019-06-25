import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HowManyPeople extends StatefulWidget {
  @override
  _HowManyPeopleState createState() => _HowManyPeopleState();
}

class _HowManyPeopleState extends State<HowManyPeople> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    int numMembers = _bloc?.currentState?.data?.numMembers;

    _textEditingController.text = numMembers?.toString() ?? '';
    return QuestionScaffold(
      title: "누구와 함께 할까요? (1명 이상)",
      body: Container(
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
                  keyboardType: TextInputType.number,
                  controller: _textEditingController,
                  style: DoitMainTheme.makeGoalUserInputTextStyle,
                  maxLength: 2,
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    counterText: "",
                    hintText: '0',
                    hintStyle: DoitMainTheme.makeGoalHintTextStyle,
                  ),
                  onChanged: (text) async {
                    MakeGoalSecondPageBloc bloc =
                        MakeGoalSecondPageBloc.getBloc(context);
                    bloc.dispatch(
                      MakeGoalSecondPageEvent(
                        action: MakeGoalSecondPageAction.setNumMembers,
                        data: text.length > 0 ? int.parse(text) : 0,
                      ),
                    );
                  },
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
    );
  }
}
