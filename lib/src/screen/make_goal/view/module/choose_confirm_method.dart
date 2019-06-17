import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
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
    List methodChips = List.generate(
      confirmMethod.length * 2 - 1,
      (index) {
        if (index % 2 == 0) {
          final ConfirmMethod method = confirmMethod[index ~/ 2];
          final String chipKey = 'confirm' + method.title + 'Icon';
          return Expanded(
            child: SelectableGradientChip(
              title: method.title,
              groupKey: 'confirmationQuestion',
              maxMultiSelectables: confirmMethod.length,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              icon: EasyStatefulBuilder(
                identifier: chipKey,
                keepAlive: false,
                initialValue: false,
                builder: (context, selected) {
                  return Icon(
                    method.icon,
                    size: 18.0,
                    color: selected ? Color(0xffffffff) : Color(0x66ffffff),
                  );
                },
              ),
              onTap: (context, _) {
                /// 아이콘 색 변경을 위한 setState
                EasyStatefulBuilder.setState(
                  chipKey,
                  (state) {
                    state.nextState = !state.currentState;
                  },
                );
              },
            ),
          );
        } else {
          // 사이 띄우는
          return SizedBox(width: 15.0);
        }
      },
    ).toList();

    return QuestionScaffold(
      title: '인증방식을 고르세요. (중복가능)',
      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: methodChips,
      ),
    );
  }
}
