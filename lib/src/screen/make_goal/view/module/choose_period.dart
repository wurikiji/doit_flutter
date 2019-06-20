import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/first_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final String startDateKey = 'goalStartDateKey';
final String endDateKey = 'goalEndDateKey';

class ChoosePeriod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      body: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          color: Color(0xff2b2b2b),
        ),
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SelectStartDateWidget(),
            ),
            SizedBox(width: 20.0),
            Container(
              width: 10.0,
              height: 2.0,
              decoration: BoxDecoration(
                color: Color(0xffa4a4a4),
                border: Border.all(
                  color: Color(0xffa4a4a4),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: SelectEndDateWidget(),
            ),
          ],
        ),
      ),
      title: '기간을 선택해주세요.',
    );
  }
}

class SelectStartDateWidget extends StatelessWidget {
  const SelectStartDateWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirstPageMakeGoalBloc _bloc =
        BlocProvider.of<FirstPageMakeGoalBloc>(context);

    return EasyStatefulBuilder(
      identifier: startDateKey,
      initialValue: null,
      keepAlive: false,
      builder: (context, DateTime date) {
        return GestureDetector(
          onTap: () async {
            DateTime date = await selectDateTime(context);
            if (date != null) {
              _bloc.dispatch(FirstPageMakeGoalInfoEvent(
                action: FirstPageMakeGoalInfoAction.setStartDate,
                data: date,
              ));
              EasyStatefulBuilder.setState(startDateKey, (state) {
                state.nextState = date;
              });
            }
          },
          child: Text(
            date == null ? "시작 날짜" : dateTimeToString(date),
            textAlign: TextAlign.end,
            style: date == null
                ? DoitMainTheme.makeGoalHintTextStyle
                : DoitMainTheme.makeGoalUserInputTextStyle,
          ),
        );
      },
    );
  }
}

class SelectEndDateWidget extends StatelessWidget {
  const SelectEndDateWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirstPageMakeGoalBloc _bloc =
        BlocProvider.of<FirstPageMakeGoalBloc>(context);
    return EasyStatefulBuilder(
      identifier: endDateKey,
      initialValue: null,
      keepAlive: false,
      builder: (context, DateTime date) {
        return GestureDetector(
          onTap: () async {
            DateTime date = await selectDateTime(context);
            if (date != null) {
              _bloc.dispatch(FirstPageMakeGoalInfoEvent(
                action: FirstPageMakeGoalInfoAction.setEndDate,
                data: date,
              ));
              EasyStatefulBuilder.setState(endDateKey, (state) {
                state.nextState = date;
              });
            }
          },
          child: Text(
            date == null ? "종료 날짜" : dateTimeToString(date),
            style: date == null
                ? DoitMainTheme.makeGoalHintTextStyle
                : DoitMainTheme.makeGoalUserInputTextStyle,
          ),
        );
      },
    );
  }
}

String dateTimeToString(DateTime date) {
  return "${date.year}년 ${date.month}월 ${date.day}일";
}

selectDateTime(BuildContext context) async {
  final DateTime now = DateTime.now();
  final DateTime dateTime = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(now.year, now.month),
    lastDate: DateTime(2999),
    selectableDayPredicate: (date) =>
        date.isAfter(now.subtract(Duration(days: 1))),
  );
  return dateTime;
}
