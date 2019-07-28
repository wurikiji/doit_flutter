import 'dart:io';
import 'dart:ui';

import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/screen/shoot/shoot_timer/doit_shoot_timer.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/shoot_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

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
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  bool canUseImage = false;
  File _mainImage;

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    setState(() {
      postStatus = widget.postStatus;
    });
  }

  getPhotoPermission() async {
    var ret = await PhotoManager.requestPermission();
    if (ret) {
      setState(() {
        canUseImage = true;
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    height /= 2.0;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: projectColors[getProjectColorIndex(widget.goal.goalColor)],
              ),
            ),
            if (widget.timer != null)
              Positioned(
                top: 79,
                right: 20.0,
                child: ProgressChip(
                  title: ((widget.timer.elapsed.inSeconds / widget.timer.target.inSeconds) * 100)
                          .toInt()
                          .toString() +
                      ' %',
                ),
              ),
            DoitShootPostAppBar(setImage: setMainImage),
            DoitPostTextField(
                mainImage: _mainImage,
                focusNode: focusNode,
                textEditingController: textEditingController),
            if (widget.timer != null)
              Align(
                alignment: Alignment(0.0, (120) / height),
                child: Text(
                  getTimeFromDuration(widget.timer.elapsed),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30.0,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        offset: Offset(0.0, 2.0),
                        color: Color(0x19000000),
                      ),
                    ],
                  ),
                ),
              ),
            Align(
              alignment: Alignment(0.0, (140 + 82) / height),
              child: DoitPostButton(
                shoot: shoot,
              ),
            ),
          ],
        ),
      ),
    );
  }

  shoot() async {
    DoitShootService.createShoot(
      DoitShootModel(
        shootName: 'hi',
        text: '' + textEditingController.text,
        goalId: widget.goal.goalId,
        shooter: DoitUserAPI.memberInfo,
        timerElapsed: widget.timer?.elapsed?.inSeconds,
        timerTarget: widget.timer?.target?.inSeconds,
      ),
    );
    Navigator.of(context).pop();
  }

  setMainImage() async {
    ImageSource which = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('카메라'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('갤러리'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
            ],
          );
        });
    File image = await ImagePicker.pickImage(source: which);
    setState(() {
      _mainImage = image;
    });
  }
}

class DoitPostButton extends StatelessWidget {
  const DoitPostButton({
    Key key,
    this.shoot,
  }) : super(key: key);

  final Function shoot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          width: double.infinity,
          height: 50.0,
          child: FlatButton(
            onPressed: () {
              shoot();
            },
            color: Color(0xff222222),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
            child: Text(
              '업로드',
              style: TextStyle(
                fontFamily: 'SpoqaHanSans',
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DoitPostTextField extends StatelessWidget {
  const DoitPostTextField({
    Key key,
    @required File mainImage,
    @required this.focusNode,
    @required this.textEditingController,
  })  : _mainImage = mainImage,
        super(key: key);

  final File _mainImage;
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          height: 280.0,
          decoration: BoxDecoration(
            color: _mainImage == null ? Colors.transparent : null,
            image: _mainImage == null
                ? null
                : DecorationImage(
                    image: FileImage(_mainImage),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: TextField(
                focusNode: focusNode,
                maxLength: 60,
                maxLines: 4,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                autofocus: true,
                controller: textEditingController,
                style: TextStyle(
                  fontFamily: 'SpoqaHanSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      offset: Offset(0.0, 2.0),
                      color: Color(0x19000000),
                    ),
                  ],
                ),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 30.0,
                  ),
                  alignLabelWithHint: true,
                  focusedBorder: null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintMaxLines: 3,
                  hintStyle: TextStyle(
                    fontFamily: 'SpoqaHanSans',
                    fontSize: 18.0,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: '오늘 Goal을 이루기 위해\n'
                      '어떤 노력했는지 적어주세요!\n'
                      '느낀 감정도 좋아요.',
                ),
                inputFormatters: <TextInputFormatter>[
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.split('\n').length > 5) {
                      return oldValue;
                    }
                    return newValue;
                  }),
                ],
                onChanged: (String text) {},
                onEditingComplete: () {
                  focusNode.unfocus();
                },
                onSubmitted: (String text) {
                  focusNode.unfocus();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DoitShootPostAppBar extends StatelessWidget {
  const DoitShootPostAppBar({
    Key key,
    this.setImage,
  }) : super(key: key);

  final Function setImage;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: 24.0,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Upload',
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'SpoqaHanSans',
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            if (setImage != null) setImage();
          },
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 24.0,
          ),
        ),
        SizedBox(width: 22.0),
      ],
    );
  }
}

class ProgressChip extends StatelessWidget {
  const ProgressChip({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: Color(0x26222222),
      ),
      child: IntrinsicWidth(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'SpoqaHanSans',
            fontSize: 10.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
