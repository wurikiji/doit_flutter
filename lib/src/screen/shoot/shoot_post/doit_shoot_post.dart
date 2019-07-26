import 'package:do_it/src/screen/shoot/shoot_timer/doit_shoot_timer.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/shoot_service.dart';
import 'package:flutter/material.dart';

enum DoitShootPostStatus { create, edit, view }

class DoitShootPost extends StatefulWidget {
  DoitShootPost({
    this.shoot,
    this.goal,
    this.postStatus = DoitShootPostStatus.create,
    this.timer,
  });

  final DoitGoalModel goal;
  final DoitShootModel shoot;
  final DoitShootPostStatus postStatus;
  final ShootTimerModel timer;
  @override
  _DoitShootPostState createState() => _DoitShootPostState();
}

class _DoitShootPostState extends State<DoitShootPost> {
  DoitShootPostStatus postStatus;

  @override
  void initState() {
    super.initState();
    setState(() {
      postStatus = widget.postStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
