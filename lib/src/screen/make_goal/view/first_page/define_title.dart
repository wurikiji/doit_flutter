import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/first_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefineTitle extends StatefulWidget {
  @override
  _DefineTitleState createState() => _DefineTitleState();
}

class _DefineTitleState extends State<DefineTitle> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = FirstPageMakeGoalBloc.getBloc(context);
    return QuestionScaffold(
      title: '프로젝트의 상세 타이틀을 적어주세요.',
      body: BlocListener(
        bloc: _bloc,
        listener: (context, FirstPageMakeGoalInfoSnapshot snapshot) {
          _controller.text = snapshot?.goal?.goalTitle;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            color: Color(0xff2b2b2b),
          ),
          child: TextField(
            controller: this._controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '주 3회 이상 운동하기',
              hintStyle: DoitMainTheme.makeGoalHintTextStyle,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            maxLines: 1,
            style: DoitMainTheme.makeGoalUserInputTextStyle,
            onChanged: (String title) async {
              FirstPageMakeGoalBloc _bloc =
                  FirstPageMakeGoalBloc.getBloc(context);
              _bloc.dispatch(
                FirstPageMakeGoalInfoEvent(
                  action: FirstPageMakeGoalInfoAction.setTitle,
                  data: title,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
