import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';

List<Gradient> projectColors = [
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffff786a),
      Color(0xfff5317f),
    ],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xfff2d026),
      Color(0xfff26a3c),
    ],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff8add4b),
      Color(0xff2eb144),
    ],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff3deba5),
      Color(0xff08bac3),
    ],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff34f687),
      Color(0xff1c87ff),
    ],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff4dc5f7),
      Color(0xff1c74e0),
    ],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff4d90fb),
      Color(0xff771de4),
    ],
  ),
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
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
    final MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    final prevIndex = _bloc.currentState.data.colorIndex;
    List<Widget> colorWidgets = List.generate(
      projectColors.length * 2 - 1,
      (index) {
        if (index % 2 == 1) return SizedBox(width: 10.0);
        final LinearGradient gradient = projectColors[index ~/ 2];
        return new DoitColorButton(
          index: index,
          groupKey: groupKey,
          gradient: gradient,
          prevIndex: prevIndex,
          bloc: _bloc,
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

class DoitColorButton extends StatelessWidget {
  const DoitColorButton({
    Key key,
    @required this.index,
    @required this.groupKey,
    @required this.gradient,
    @required this.prevIndex,
    @required MakeGoalSecondPageBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final int index;
  final String groupKey;
  final LinearGradient gradient;
  final int prevIndex;
  final MakeGoalSecondPageBloc _bloc;

  @override
  Widget build(BuildContext context) {
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
          maxMultiSelectables: 1,
          initialSelected: (index ~/ 2) == prevIndex,
          unseletedGradient: LinearGradient(
            colors: [
              gradient.colors[0].withOpacity(0.3),
              gradient.colors[1].withOpacity(0.3),
            ],
          ),
          onTap: (context, List<SelectableGradientChip> value) {
            final gIndex = value.isEmpty ? invalidColor : value[0].value;
            _bloc.dispatch(
              MakeGoalSecondPageEvent(
                action: MakeGoalSecondPageAction.setProjectColor,
                data: gIndex,
              ),
            );
          },
          duration: Duration.zero,
          selectedDecoration: Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: const Color(0xffffffff),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
