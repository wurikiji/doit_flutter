import 'dart:async';

import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';

class CategoryService {
  static get allCategory => _getAllCategory();
  static Future<List<CategoryModel>> _getAllCategory() async {
    return [
      CategoryModel(id: GoalCategory.sport, title: "운동"),
      CategoryModel(id: GoalCategory.study, title: "공부"),
      CategoryModel(id: GoalCategory.hobby, title: "취미"),
      CategoryModel(id: GoalCategory.saveMoney, title: "저축"),
      CategoryModel(id: GoalCategory.travel, title: "여행"),
      CategoryModel(id: GoalCategory.diet, title: "다이어트"),
      CategoryModel(id: GoalCategory.etc, title: "기타"),
    ];
  }

  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(id: GoalCategory.sport, title: "운동"),
      CategoryModel(id: GoalCategory.study, title: "공부"),
      CategoryModel(id: GoalCategory.hobby, title: "취미"),
      CategoryModel(id: GoalCategory.saveMoney, title: "저축"),
      CategoryModel(id: GoalCategory.travel, title: "여행"),
      CategoryModel(id: GoalCategory.diet, title: "다이어트"),
      CategoryModel(id: GoalCategory.etc, title: "기타"),
    ];
  }

  static String getCategoryName(GoalCategory category) => getCategories()
      .singleWhere(
        (item) => item.id == category,
      )
      .title;
}

class CategoryModel {
  const CategoryModel({this.id, this.title});
  final String title;
  final GoalCategory id;
}
