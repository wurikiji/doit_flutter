import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const List<ConfirmMethod> confirmMethod = [
  const ConfirmMethod(
    title: '사진',
    icon: FontAwesomeIcons.camera,
  ),
  const ConfirmMethod(
    title: '글',
    icon: FontAwesomeIcons.envelopeOpenText,
  ),
  const ConfirmMethod(
    title: '타이머',
    icon: FontAwesomeIcons.stopwatch,
  ),
];

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
    return QuestionScaffold(
      title: '인증방식을 고르세요. (중복가능)',
      children: <Widget>[
        // TODO: Listview horizontal 로 변경하고 separator로 중간 띄어 줘야함.
        // TODO: icon theme 유동적으로 변경할 방법이 필요함.
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: confirmMethod
              .map(
                (method) => Expanded(
                  child: SelectableGradientChip(
                    title: method.title,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    icon: Icon(method.icon),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
