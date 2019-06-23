import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';

List<Gradient> projectColors = [
  LinearGradient(
    colors: [
      Color(0xffff786a),
      Color(0xfff5317f),
    ],
  ),
  LinearGradient(
    colors: [
      Color(0xfff2d026),
      Color(0xfff26a3c),
    ],
  ),
  LinearGradient(colors: [
    Color(0xff8add4b),
    Color(0xff2eb144),
  ]),
  LinearGradient(
    colors: [
      Color(0xff3deba5),
      Color(0xff08bac3),
    ],
  ),
  LinearGradient(
    colors: [
      Color(0xff34f687),
      Color(0xff1c87ff),
    ],
  ),
  LinearGradient(
    colors: [
      Color(0xff4dc5f7),
      Color(0xff1c74e0),
    ],
  ),
  LinearGradient(
    colors: [
      Color(0xff4d90fb),
      Color(0xff771de4),
    ],
  ),
  LinearGradient(
    colors: [
      Color(0xffff63de),
      Color(0xff9c13cd),
    ],
  ),
];

class ProjectColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String groupKey = 'projectColor';
    List<Widget> colorWidgets = List.generate(
      projectColors.length * 2 - 1,
      (index) {
        if (index % 2 == 1) return SizedBox(width: 10.0);
        final LinearGradient gradient = projectColors[index ~/ 2];
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: SelectableGradientChip(
              title: '',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              groupKey: groupKey,
              gradient: gradient,
              value: index ~/ 2,
              unseletedGradient: LinearGradient(
                colors: [
                  gradient.colors[0].withOpacity(0.3),
                  gradient.colors[1].withOpacity(0.3),
                ],
              ),
            ),
          ),
        );
      },
    );
    return QuestionScaffold(
      title: '프로젝트의 컬러를 선택하세요.',
      body: Row(
        children: colorWidgets,
      ),
    );
  }
}
