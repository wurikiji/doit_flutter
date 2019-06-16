import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:flutter/material.dart';

class ChoosePeriod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      body: RaisedButton(
        child: Text("click"),
        onPressed: () async {
          final DateTime now = DateTime.now();
          final DateTime dateTime = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(now.year, now.month),
            lastDate: DateTime(2999),
            selectableDayPredicate: (date) =>
                date.isAfter(now.subtract(Duration(days: 1))),
          );
          print(dateTime);
        },
      ),
      title: '기간을 선택해주세요.',
    );
  }
}
