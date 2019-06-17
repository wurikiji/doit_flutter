import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:do_it/src/service/api/category_service.dart';
import 'package:flutter/material.dart';

class ChooseCategory extends StatelessWidget {
  final Future categoryList = CategoryService.allCategory;
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
              children: (snapshot.data as List)
                  .map(
                    (category) => SelectableGradientChip(
                      title: category,
                      groupKey: 'categoryQuestion',
                      maxMultiSelectables: 1,
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
