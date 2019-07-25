import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/goal_timeline.dart/goal_timeline.dart';
import 'package:do_it/src/screen/main/common/goal_card.dart';
import 'package:do_it/src/screen/main/view/card_progress_indicator.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rest_api_test/kakao_link/kakao_link.dart';

const buttonColors = <Color>[
  Color(0xfff63b7c),
  Color(0xfff27539),
  Color(0xff38b544),
  Color(0xff11c2bf),
  Color(0xff1d91f4),
  Color(0xff2583e4),
  Color(0xff7031e8),
  Color(0xffab20d0),
];

void inviteToGoal(BuildContext context, DoitGoalModel goal) async {
  final String link = await DoitGoalService.getInvitationLink(goal);
  final String start = (DateFormat('yyyy-MM-dd').format(goal.startDate));
  final String end = (DateFormat('yyyy-MM-dd').format(goal.endDate));
  final String range = '$start ~ $end';
  print("INVITATION LINK IS $link");

  await KakaoLinkAPI.createLink(
    context,
    jsApiKey: 'd1e9c1de1d0217411077aa58ca4fa26a',
    androidUrl: link,
    title: goal.goalName,
    description: '${DoitUserAPI.memberInfo.name}이 Doit으로 초대합니다! ($range)',
    imageUrl: 'https://dl.dropbox.com/s/190w2y9vw47elfs/img_app_icon.png',
  );
}

class UserGoalCard extends StatelessWidget {
  const UserGoalCard({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isStarted(goal)) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DoitTimeline(
                goal: goal,
              ),
            ),
          );
        }
      },
      child: DoitMainCard(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CardTitleBar(goal: goal),
              CardGoalPeriod(goal: goal),
              SizedBox(height: 10.0),
              CardCategoryChip(goal: goal),
              SizedBox(height: 20.0),
              Container(
                height: 190,
                padding: const EdgeInsets.only(
                  right: 10.0,
                ),
                child: CardProgressIndicator(
                  goal: goal,
                ),
              ),
              SizedBox(height: 30.0),
              if (!isStarted(goal))
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Center(child: CardInvitationButton(goal: goal)),
                ),
              if (isStarted(goal))
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: 20.0,
                    child: DoitGoalMemberListBar(goal: goal),
                  ),
                ),
            ],
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: projectColors[getProjectColorIndex(goal.goalColor)].colors,
        ),
      ),
    );
  }
}

class DoitGoalMemberListBar extends StatefulWidget {
  const DoitGoalMemberListBar({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  _DoitGoalMemberListBarState createState() => _DoitGoalMemberListBarState();
}

class _DoitGoalMemberListBarState extends State<DoitGoalMemberListBar> {
  Future<List<DoitMember>> memberList;

  @override
  void initState() {
    super.initState();
    memberList = DoitGoalService.getMembers(widget.goal);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoitMember>>(
      future: memberList,
      builder: (context, memberList) {
        if (memberList.hasData) {
          final int numMembers = memberList.data.length;
          final double leftPadding = 17.0;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              for (int i = numMembers - 1; i >= 0; i--)
                Positioned(
                  left: i * leftPadding,
                  top: 0.0,
                  child: DoitMemberThumbnail(
                    profileUrl: memberList.data[0]?.profileImageUrl,
                  ),
                ),
              Positioned(
                left: leftPadding * (numMembers - 1) + 20.0 + 8.0,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${memberList.data[0].name} ',
                          style: nameTextStyle,
                        ),
                        TextSpan(
                          text: '외 ',
                          style: etcTextStyle,
                        ),
                        TextSpan(
                          text: '$numMembers',
                          style: nameTextStyle,
                        ),
                        TextSpan(
                          text: '명 참여중',
                          style: etcTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: RefreshProgressIndicator(),
          );
        }
      },
    );
  }
}

const TextStyle nameTextStyle = TextStyle(
  fontFamily: 'SpoqaHanSans',
  fontWeight: FontWeight.w700,
  fontSize: 10.0,
  fontStyle: FontStyle.normal,
);
const TextStyle etcTextStyle = TextStyle(
  fontFamily: 'SpoqaHanSans',
  fontWeight: FontWeight.w400,
  fontSize: 10.0,
  fontStyle: FontStyle.normal,
);

class DoitMemberThumbnail extends StatelessWidget {
  const DoitMemberThumbnail({
    Key key,
    @required this.profileUrl,
  }) : super(key: key);

  final String profileUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: ClipOval(
          child: profileUrl != null
              ? Image(
                  image: CachedNetworkImageProvider(profileUrl, errorListener: () {}),
                )
              : Icon(Icons.person, size: 14.0),
        ),
      ),
    );
  }
}

class CardCategoryChip extends StatelessWidget {
  const CardCategoryChip({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

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
          goal.categoryName,
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

class CardGoalPeriod extends StatelessWidget {
  const CardGoalPeriod({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(DateFormat('yyyy-MM-dd').format(goal.startDate)),
        Text(" ~ "),
        Text(DateFormat('yyyy-MM-dd').format(goal.endDate)),
      ],
    );
  }
}

// 친구 초대 버튼
class CardInvitationButton extends StatelessWidget {
  const CardInvitationButton({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 160.0,
      child: FlatButton(
        onPressed: () {
          inviteToGoal(context, goal);
        },
        shape: StadiumBorder(),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.person_add,
              color: buttonColors[getProjectColorIndex(goal.goalColor)],
              size: 14.0,
            ),
            SizedBox(width: 4.0),
            Text(
              "같이 할 친구 초대하기",
              style: TextStyle(
                  fontFamily: "SpoqaHanSans",
                  color: buttonColors[getProjectColorIndex(goal.goalColor)],
                  fontSize: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}

int getProjectColorIndex(String stringColors) {
  List<String> stringColorList = stringColors.split(RegExp(':')).toList();
  List<Color> colorList = stringColorList.map((color) {
    String refine = color.substring(1);
    int colorInt = int.parse(refine, radix: 16);
    return Color(colorInt | 0xff000000);
  }).toList();
  for (var gradient in projectColors) {
    int count = 0;
    for (var pcolor in gradient.colors) {
      for (var color in colorList) {
        if (pcolor == color) count++;
      }
    }
    if (count >= 2) return projectColors.indexOf(gradient);
  }
  return 0;
}

class CardTitleBar extends StatelessWidget {
  const CardTitleBar({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          goal.goalName,
          style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(fontSize: 24.0),
        ),
        GestureDetector(
          child: Image.asset('assets/images/btn_more_n.png'),
          onTap: () async {
            await showCupertinoModalPopup(
              context: context,
              builder: (context) => CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text("친구 초대 링크 보내기"),
                    onPressed: () {
                      inviteToGoal(context, goal);
                    },
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {},
                    child: Text("Goal 나가기"),
                    isDestructiveAction: true,
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("취소"),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
