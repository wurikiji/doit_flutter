import 'package:flutter/material.dart';

import 'package:do_it/src/color/doit_theme.dart';

class QuestionScaffold extends StatelessWidget {
  QuestionScaffold({
    @required this.body,
    @required this.title,
    Key key,
  }) : super(key: key);

  final String title;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          QuestionTitle(title: this.title),
          SizedBox(height: 8.0),
        ]..add(this.body),
      ),
    );
  }
}

class QuestionTitle extends StatelessWidget {
  QuestionTitle({
    @required this.title,
    Key key,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        this.title,
        style: DoitMainTheme.makeGoalQuestionTitleStyle,
      ),
    );
  }
}
