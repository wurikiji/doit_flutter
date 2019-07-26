import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/shoot_service.dart';
import 'package:flutter/material.dart';

class ShootlistView extends StatefulWidget {
  ShootlistView({
    @required this.goal,
  });

  final DoitGoalModel goal;
  @override
  _ShootlistViewState createState() => _ShootlistViewState();
}

class _ShootlistViewState extends State<ShootlistView> {
  @override
  void initState() {
    super.initState();
    DoitShootService.initialize();
    DoitShootService.getShoots(widget.goal);
  }

  @override
  void dispose() {
    DoitShootService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DoitShootService.shootNotifier.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: RefreshProgressIndicator(),
          );
        } else {
          if (DoitShootService.shootList.isEmpty) {
            return Center(
              child: Text(
                '아래의 버튼을 눌러 슛을 하세요!',
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2), () {});
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16.0),
              itemCount: DoitShootService.shootList.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text(
                    DoitShootService.shootList[0].shootName,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class DoitShootCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
