import 'dart:async';

class CategoryService {
  static get allCategory => _getAllCategory();
  static Future<List<String>> _getAllCategory() async {
    return [
      "운동",
      "공부",
      "취미",
      "저축",
      "여행",
      "다이어트",
      "기타",
    ];
  }
}
