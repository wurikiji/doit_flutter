import 'dart:io';
import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/screen/shoot/shoot_timer/doit_shoot_timer.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/shoot_service.dart';
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
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: projectColors[getProjectColorIndex(widget.goal.goalColor)],
              ),
            ),
            DoitShootPostAppBar(setImage: setMainImage),
            SafeArea(
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
                      height: 300,
                      child: TextField(
                        focusNode: focusNode,
                        maxLength: 60,
                        maxLines: 5,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        autofocus: true,
                        controller: textEditingController,
                        style: TextStyle(
                          fontFamily: 'SpoqaHanSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
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
            ),
            Align(
              alignment: Alignment(0.0, (140 + 82) / height),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    child: FlatButton(
                      onPressed: () {
                        // TODO : 슛
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
              ),
            ),
          ],
        ),
      ),
    );
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
