import 'package:do_it/src/color/doit_theme.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

typedef SelectableChipOnTap = Function(BuildContext, dynamic);

class SelectableGradientChip<T> extends StatelessWidget {
  SelectableGradientChip({
    @required this.title,
    this.shape,
    this.value,
    Key key,
    final this.initialSelected = false,
    this.onTap,
    this.gradient,
    this.icon,
    this.groupKey,
    this.maxMultiSelectables = 1,
  }) : super(key: key);

  /// chip 에 표시할 제목
  final String title;

  /// 이전에 선택이 됐던 칩인지 아닌지 표시
  final bool initialSelected;

  /// 칩의 모양
  final ShapeBorder shape;

  /// onTap 함수에 전달 받을 chip 식별 값
  final T value;

  /// 칩을 클릭했을 때, 활성화 이외에 추가로 수행할 작업
  final SelectableChipOnTap onTap;

  /// 칩이 선택됐을 떄의 그라디언트
  final Gradient gradient;

  /// 제목 앞에 표시할 아이콘
  final Widget icon;

  /// 속한 그룹의 키 값
  final String groupKey;

  /// 속한 그룹의 최대 동시 선택 가능 객체 값
  final int maxMultiSelectables;

  @override
  Widget build(BuildContext context) {
    String stateIdentifier = title + 'chip';
    return EasyStatefulBuilder(
      identifier: groupKey,
      initialValue: [],
      keepAlive: false,
      builder: (context, List selectedChips) => EasyStatefulBuilder(
        identifier: stateIdentifier,
        keepAlive: false,
        initialValue: this.initialSelected,
        builder: (context, selected) {
          return GestureDetector(
            onTap: () {
              print("tapped ${this.title}");
              if (groupKey != null) {
                // TODO: 코드가 비슷하므로 refactor 가능성이 매우 높다.
                if (selected) {
                  EasyStatefulBuilder.setState(stateIdentifier, (state) {
                    state.nextState = false;
                  });
                  EasyStatefulBuilder.setState(groupKey, (state) {
                    (state.currentState as List).remove(this);
                    state.nextState = state.currentState;
                  });
                } else if (selectedChips.length < this.maxMultiSelectables) {
                  EasyStatefulBuilder.setState(stateIdentifier, (state) {
                    state.nextState = true;
                  });
                  EasyStatefulBuilder.setState(groupKey, (state) {
                    (state.currentState as List).add(this);
                    state.nextState = state.currentState;
                  });
                } else {
                  EasyStatefulBuilder.setState(groupKey, (state) {
                    final List current = (state.currentState as List);
                    final SelectableGradientChip firstWidget = current[0];

                    final String identifier = firstWidget.title + 'chip';
                    EasyStatefulBuilder.setState(identifier, (state) {
                      state.nextState = false;
                    });
                    EasyStatefulBuilder.setState(stateIdentifier, (state) {
                      state.nextState = true;
                    });
                    current.removeAt(0);
                    current.add(this);
                    state.nextState = current;
                  });
                }
                if (this.onTap != null)
                  this.onTap(context, EasyStatefulBuilder.getState(groupKey));
              } else {
                if (this.onTap != null) this.onTap(context, this.value);
                EasyStatefulBuilder.setState(stateIdentifier, (state) {
                  state.nextState = !state.currentState;
                });
              }
            },
            child: AnimatedContainer(
              padding:
                  const EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
              duration: const Duration(milliseconds: 200),
              decoration: ShapeDecoration(
                shape: this.shape ??
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                gradient: selected
                    ? (this.gradient ??
                        LinearGradient(
                          colors: [
                            Color(0xff771de4),
                            Color(0xff4d90fb),
                          ],
                        ))
                    : LinearGradient(
                        colors: [
                          Color(0xff2b2b2b),
                          Color(0xff2b2b2b),
                        ],
                      ),
              ),
              child: IntrinsicWidth(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (this.icon != null) this.icon,
                      if (this.icon != null) SizedBox(width: 8.0),
                      Text(
                        this.title,
                        style: selected
                            ? DoitMainTheme.makeGoalSelectedCategory
                            : DoitMainTheme.makeGoalUnselectedCategory,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
