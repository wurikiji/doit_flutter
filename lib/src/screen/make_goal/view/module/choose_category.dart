import 'package:do_it/src/screen/make_goal/bloc/first_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:do_it/src/service/api/category_service.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

class ChooseCategory extends StatelessWidget {
  final Future<List<CategoryModel>> categoryList = CategoryService.allCategory;
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      title: '카테고리를 고르세요.',
      body: FutureBuilder(
        future: this.categoryList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot?.hasData ?? false) {
            return Wrap(
              runSpacing: 10.0,
              spacing: 10.0,
              children: (snapshot.data as List<CategoryModel>)
                  .map(
                    (category) => Container(
                      height: 30.0,
                      child: SelectableGradientChip(
                        title: category.title,
                        groupKey: 'categoryQuestion',
                        maxMultiSelectables: 1,
                        value: category,
                        onTap: (context, selected) {
                          final FirstPageMakeGoalBloc _bloc =
                              FirstPageMakeGoalBloc.getBloc(context);
                          final selectedList =
                              (selected as ImmutableState).currentState as List;

                          CategoryModel selectedCategory;
                          if (selectedList.isNotEmpty) {
                            selectedCategory = selectedList.elementAt(0).value;
                          }
                          if ((selectedList?.length ?? 0) > 1) {
                            print("Can't be here: Multi category error");
                          }
                          _bloc.dispatch(
                            FirstPageMakeGoalInfoEvent(
                              action: FirstPageMakeGoalInfoAction.setCategory,
                              data: selectedCategory?.id ?? GoalCategory.none,
                            ),
                          );
                        },
                      ),
                    ),
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
    );
  }
}
