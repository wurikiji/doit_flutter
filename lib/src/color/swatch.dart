import 'package:flutter/material.dart';

const int doitPrimaryColorValue = 0xff222222;
const MaterialColor doitMainSwatch = MaterialColor(
  doitPrimaryColorValue,
  <int, Color>{
    50: Color(0xFFffffff),
    100: Color(0x11ffffff),
    200: Color(0x22ffffff), // 칩 위 혹은 플레이스 홀더로 쓰이는 색인데, 맞는가?
    300: Color(0x33ffffff), // 배경 바로 위에 사용되는 반투명 버튼 색
    400: Color(0xff2b2b2b), // 칩이나 배경 바로 위에 사용되는 색
    500: Color(doitPrimaryColorValue),
    600: Color(0xFF1b1b1b), // 완전 검은색의 텍스트 표시
    700: Color(0xFF111111),
    800: Color(0xff0b0b0b),
    900: Color(0xFF000000),
  },
);
