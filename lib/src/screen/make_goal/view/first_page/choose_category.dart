import 'package:do_it/src/screen/make_goal/bloc/first_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:do_it/src/service/api/category_service.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseCategory extends StatelessWidget {
  final Future<List<CategoryModel>> categoryList = CategoryService.allCategory;
  @override
  Widget build(BuildContext context) {
    final String groupKey = 'categoryQuestion';
    return QuestionScaffold(
      title: '카테고리를 고르세요.',
      body: FutureBuilder(
        future: this.categoryList,
        builder: (context, AsyncSnapshot snapshot) {
          final FirstPageMakeGoalBloc _bloc = FirstPageMakeGoalBloc.getBloc(context);
          if (EasyStatefulBuilder.getState(groupKey) != null) {
            // 새로 build 될때는 초기화 해야한다.
            try {
              EasyStatefulBuilder.setState(groupKey, (state) {
                state.nextState = <SelectableGradientChip>[];
              });
            } catch (e) {}
          }
          if (snapshot?.hasData ?? false) {
            List<CategoryModel> categories = snapshot.data;
            return BlocBuilder(
              bloc: _bloc,
              builder: (context, FirstPageMakeGoalInfoSnapshot snapshot) => Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                // alignment: WrapAlignment.center,
                children: [
                  for (int i in List.generate(categories.length, (index) => index))
                    Container(
                      height: 30.0,
                      child: SelectableGradientChip(
                        intrinsicSize: true,
                        title: categories[i].title,
                        groupKey: groupKey,
                        maxMultiSelectables: 1,
                        value: categories[i],
                        initialSelected: (snapshot?.goal?.category?.index ?? GoalCategory.none) == i,
                        onTap: (context, selected) {
                          final selectedList = selected;

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
                ],
              ),
            );
          } else {
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
