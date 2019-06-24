import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';

class DaysPerWeek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> selectableDays = List.generate(
      13,
      (index) {
        int days = (index ~/ 2) + 1;
        if (index % 2 == 1) {
          return SizedBox(width: 8.0);
        }
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: SelectableGradientChip(
              title: '$days',
              value: days,
              groupKey: 'howManyDaysPerWeek',
              maxMultiSelectables: 1,
              onTap: (context, value) {},
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        );
      },
    );
    return Row(
      children: selectableDays,
    );
  }
}
