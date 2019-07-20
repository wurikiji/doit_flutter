import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';

class DoitShoot extends StatelessWidget {
  const DoitShoot({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset('assets/images/outline_clear_24_px.png'),
        ),
        centerTitle: true,
        title: Text("Goals"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 90.0),
        itemCount: hi.length,
        separatorBuilder: (context, index) => SizedBox(height: 60.0),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // TODO: 슛 화면으로 바로가기
              print("SHoooooot");
            },
            child: Center(
              child: Text(
                hi[index].goal.firstPage.goalTitle,
                style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                  fontFamily: "SpoqaHanSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
