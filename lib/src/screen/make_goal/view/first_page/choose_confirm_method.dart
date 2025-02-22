import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/first_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const willUseTimer = ConfirmMethod(
  title: '타이머 사용',
  icon: FontAwesomeIcons.stopwatch,
);

class ConfirmMethod {
  const ConfirmMethod({
    this.icon,
    @required this.title,
  });
  final String title;
  final IconData icon;
}

class ChooseConfirmMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfirmMethod method = willUseTimer;
    final String chipKey = 'confirm' + method.title + 'Icon';
    final String groupKey = "willUseTimerQuestion";

    return QuestionScaffold(
      title: '타이머 사용여부를 선택해주세요.',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            WillUseTimerQuestionWidget(
              method: method,
              groupKey: groupKey,
              chipKey: chipKey,
            ),
            SizedBox(width: 14.0),
            ConfirmMethodsNotice(),
          ],
        ),
      ),
    );
  }
}

class ConfirmMethodsNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 14.0,
                height: 14.0,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(colors: [
                    Color(0xff4d90fb),
                    Color(0xff771de4),
                  ]),
                ),
                child: Center(
                  child: Text(
                    "!",
                    style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(
                      fontSize: 11.0,
                      height: 0.9,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.0),
              Text(
                "알려드려요",
                style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(fontSize: 12.0),
              ),
            ],
          ),
          SizedBox(height: 5.5),
          Text(
            "기본 인증방식은 글+사진 입니다.",
            style: DoitMainTheme.makeGoalUserInputTextStyle.copyWith(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}

class WillUseTimerQuestionWidget extends StatelessWidget {
  const WillUseTimerQuestionWidget({
    Key key,
    @required this.method,
    @required this.groupKey,
    @required this.chipKey,
  }) : super(key: key);

  final ConfirmMethod method;
  final String groupKey;
  final String chipKey;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder(
        bloc: FirstPageMakeGoalBloc.getBloc(context),
        builder: (context, FirstPageMakeGoalInfoSnapshot snapshot) => Container(
          height: 40.0,
          child: SelectableGradientChip(
            title: method.title,
            value: 0,
            groupKey: groupKey,
            maxMultiSelectables: 1,
            initialSelected: snapshot?.goal?.useTimer ?? false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            icon: Icon(
              method.icon,
              size: 18.0,
              color: (snapshot?.goal?.useTimer ?? false) ? Color(0xffffffff) : Color(0x66ffffff),
            ),
            onTap: (context, selected) {
              final FirstPageMakeGoalBloc _bloc = FirstPageMakeGoalBloc.getBloc(context);
              final selectedList = selected;

              bool useTimer = false;
              if (selectedList.isNotEmpty) {
                useTimer = true;
              }
              if ((selectedList?.length ?? 0) > 1) {
                print("Can't be here: Multi category error");
              }
              _bloc.dispatch(
                FirstPageMakeGoalInfoEvent(
                  action: FirstPageMakeGoalInfoAction.setUseTimer,
                  data: useTimer,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
