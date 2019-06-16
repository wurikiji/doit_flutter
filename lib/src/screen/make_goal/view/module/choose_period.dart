import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:flutter/material.dart';

class ChoosePeriod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      body: RaisedButton(
        child: Text("click"),
        onPressed: () async {
          final DateTime dateTime = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime(2999),
          );
          print(dateTime);
        },
      ),
      title: '기간을 선택해주세요.',
    );
  }
}
