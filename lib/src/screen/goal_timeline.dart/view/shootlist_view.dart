import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/shoot_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

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
        DoitShootService.shootList.sort(
          (shoot1, shoot2) => shoot2.shootDate.difference(shoot1.shootDate).inMilliseconds,
        );
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
              await DoitShootService.getShoots(widget.goal);
            },
            child: ListView.builder(
              itemCount: DoitShootService.shootList.length,
              itemBuilder: (context, index) {
                return DoitShootCard(
                  shoot: DoitShootService.shootList[index],
                  index: index,
                );
              },
            ),
          );
        }
      },
    );
  }
}

class DoitShootCard extends StatefulWidget {
  DoitShootCard({
    @required this.shoot,
    @required this.index,
  });
  final DoitShootModel shoot;
  final int index;

  @override
  _DoitShootCardState createState() => _DoitShootCardState();
}

class _DoitShootCardState extends State<DoitShootCard> {
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DoitShootPostTitleBar(
          shoot: widget.shoot,
          index: widget.index,
          screenshotController: screenshotController,
        ),
        SizedBox(height: 10.0),
        DoitShootPostBody(
          screenshotController: screenshotController,
          key: GlobalObjectKey(widget.shoot),
          shoot: widget.shoot,
        ),
        SizedBox(height: 10.0),
        DoitPostSocialBar(
          shoot: widget.shoot,
          index: widget.index,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}

class DoitPostSocialBar extends StatefulWidget {
  const DoitPostSocialBar({
    Key key,
    @required this.shoot,
    this.index,
  }) : super(key: key);

  final DoitShootModel shoot;
  final int index;

  @override
  _DoitPostSocialBarState createState() => _DoitPostSocialBarState();
}

class _DoitPostSocialBarState extends State<DoitPostSocialBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            print("mid: ${DoitUserAPI.memberInfo.memberId}, sid: ${widget.shoot.shootId}");
            setState(() {
              if (widget.shoot.didILike) {
                // widget.shoot.numLike--;
                DoitShootService.setSocialCounter(
                  DoitSocialType.likeDown,
                  widget.shoot,
                  widget.index,
                );
              } else {
                // widget.shoot.numLike++;
                DoitShootService.setSocialCounter(
                  DoitSocialType.likeUp,
                  widget.shoot,
                  widget.index,
                );
              }
            });
          },
          child: Row(
            children: <Widget>[
              Icon(
                widget.shoot.didILike ? FontAwesomeIcons.solidLaugh : FontAwesomeIcons.laugh,
                size: 24.0,
                color: Colors.white.withOpacity(widget.shoot.didILike ? 1.0 : 0.7),
              ),
              SizedBox(width: 10.0),
              Text(
                '${widget.shoot.numLike}',
                style: TextStyle(
                  fontFamily: 'SpoqaHanSans',
                  fontSize: 14.0,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.0),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              if (widget.shoot.didIdislike) {
                // widget.shoot.numDislike--;
                DoitShootService.setSocialCounter(
                  DoitSocialType.dislikeDown,
                  widget.shoot,
                  widget.index,
                );
              } else {
                // widget.shoot.numDislike++;
                DoitShootService.setSocialCounter(
                  DoitSocialType.dislikeUp,
                  widget.shoot,
                  widget.index,
                );
              }
              // widget.shoot.didIdislike = !widget.shoot.didIdislike;
            });
          },
          child: Row(
            children: <Widget>[
              Icon(
                widget.shoot.didIdislike ? FontAwesomeIcons.solidFrown : FontAwesomeIcons.frown,
                size: 24.0,
                color: Colors.white.withOpacity(widget.shoot.didIdislike ? 1.0 : 0.7),
              ),
              SizedBox(width: 10.0),
              Text(
                '${widget.shoot.numDislike}',
                style: TextStyle(
                  fontFamily: 'SpoqaHanSans',
                  fontSize: 14.0,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.0),
      ],
    );
  }
}

class DoitShootPostTitleBar extends StatelessWidget {
  const DoitShootPostTitleBar({
    Key key,
    @required this.shoot,
    @required this.index,
    @required this.screenshotController,
  }) : super(key: key);

  final int index;
  final DoitShootModel shoot;
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 20.0),
          Container(
            width: 40.0,
            height: 40.0,
            child: CircleAvatar(
              child: ClipOval(
                child: (shoot.shooter.profileImageUrl != null)
                    ? Image(
                        image: CachedNetworkImageProvider(shoot.shooter.profileImageUrl),
                        fit: BoxFit.fill,
                      )
                    : Icon(
                        Icons.person,
                        size: 24.0,
                      ),
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                shoot.shooter.name,
                style: TextStyle(
                  fontFamily: 'SpoqaHanSans',
                  fontSize: 14.0,
                  color: Colors.white.withOpacity(0.91),
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                DateFormat('yyyy.MM.dd hh:mm a').format(shoot.shootDate),
                style: TextStyle(
                  fontFamily: 'SpoqaHanSans',
                  fontSize: 12.0,
                  letterSpacing: 1.29,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 수정 삭제 공유
              showCupertinoModalPopup(
                builder: (context) {
                  return CupertinoActionSheet(
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'),
                    ),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text('수정'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Text('공유'),
                        onPressed: () {
                          screenshotController.capture().then((File image) async {
                            await prefix0.Share.file(
                              'My Doit',
                              'doit.jpg',
                              await image.readAsBytes(),
                              'image/jpg',
                            );
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      if (shoot.shooter.memberId == DoitUserAPI.memberInfo.memberId)
                        CupertinoActionSheetAction(
                          child: Text('삭제'),
                          onPressed: () {
                            DoitShootService.deleteShoot(
                              shoot,
                              index,
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                    ],
                  );
                },
                context: context,
              );
            },
            child: Container(
              width: 30.0,
              alignment: Alignment.centerRight,
              child: Image.asset('assets/images/btn_more_n.png'),
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),
    );
  }
}

class DoitShootPostBody extends StatefulWidget {
  const DoitShootPostBody({
    Key key,
    @required this.shoot,
    @required this.screenshotController,
  }) : super(key: key);

  final DoitShootModel shoot;
  final ScreenshotController screenshotController;

  @override
  _DoitShootPostBodyState createState() => _DoitShootPostBodyState();
}

class _DoitShootPostBodyState extends State<DoitShootPostBody> {
  @override
  Widget build(BuildContext context) {
    final int goalColor = widget.shoot.shootId % projectColors.length;
    return Screenshot(
      controller: widget.screenshotController,
      child: Container(
        height: 270.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.shoot.imageUrl == null ? projectColors[goalColor] : null,
            image: widget.shoot.imageUrl != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.shoot.imageUrl,
                    ),
                  )
                : null,
          ),
          child: Stack(
            children: <Widget>[
              if (widget.shoot.timerElapsed != null) Container(),
              Center(
                child: Text(
                  widget.shoot.text,
                  style: TextStyle(
                      fontFamily: 'SpoqaHanSans',
                      fontSize: 18.0,
                      height: 24.0 / 18.0,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 1.0,
                          offset: Offset(0.0, 2.0),
                          color: Color(0x19000000),
                        ),
                      ]),
                ),
              ),
              if (widget.shoot.timerElapsed != null)
                Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Text(
                        getTimeFromDuration(Duration(seconds: widget.shoot.timerElapsed)),
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
                    SizedBox(
                      height: 32.0,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
