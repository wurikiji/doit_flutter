import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/service/api/category_service.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

class ChooseCategory extends StatelessWidget {
  final Future categoryList = CategoryService().getAllCategory;
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      title: '카테고리를 고르세요.',
      children: <Widget>[
        FutureBuilder(
          future: this.categoryList,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot?.hasData ?? false) {
              return Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                children: (snapshot.data as List)
                    .map(
                      (value) => SelectableCategoryChip(title: value),
                    )
                    .toList(),
              );
            } else {
              print("Not yet loaded categories");
              return Container(
                child: Center(
                  child: RefreshProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

/// Category bloc 을 따로 사용해야 더 빠른 성능을 낼 수 있다.
/// 전체 Goal bloc 은 '다음' 버튼을 누를 때만 저장하도록 하자.

class SelectableCategoryChip extends StatelessWidget {
  SelectableCategoryChip({
    @required this.title,
    Key key,
    final this.initialSelected = false,
  }) : super(key: key);

  final String title;
  bool initialSelected;

  @override
  Widget build(BuildContext context) {
    String stateIdentifier = title + 'chip';
    return EasyStatefulBuilder(
      identifier: stateIdentifier,
      keepAlive: false,
      initialValue: this.initialSelected,
      builder: (context, selected) {
        return GestureDetector(
          onTap: () {
            print("tapped ${this.title}");
            EasyStatefulBuilder.setState(stateIdentifier, (state) {
              state.nextState = !state.currentState;
            });
          },
          child: AnimatedContainer(
            padding:
                const EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
            duration: const Duration(milliseconds: 200),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              gradient: LinearGradient(
                colors: [
                  selected ? Color(0xff771de4) : Color(0xff2b2b2b),
                  selected ? Color(0xff4d90fb) : Color(0xff2b2b2b),
                ],
              ),
            ),
            child: Text(
              this.title,
              style: selected
                  ? DoitMainTheme.makeGoalSelectedCategory
                  : DoitMainTheme.makeGoalUnselectedCategory,
            ),
          ),
        );
      },
    );
  }
}
