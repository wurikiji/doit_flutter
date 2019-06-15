import 'package:do_it/src/screen/make_goal/view/module/choose_category.dart';
import 'package:do_it/src/screen/make_goal/view/module/define_title.dart';
import 'package:flutter/material.dart';

class MakeGoalFirstPage extends StatelessWidget {
  final List<Widget> questionList = [
    ChooseCategory(),
    DefineTitle(),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 42.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 50.0),
              itemCount: this.questionList.length,
              itemBuilder: (context, index) => this.questionList[index],
            ),
          ),
        ],
      ),
    );
  }
}
