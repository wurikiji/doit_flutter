import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/page_navigation_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/progress_bloc.dart';
import 'package:do_it/src/screen/make_goal/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeGoalAppBar extends AppBar {
  MakeGoalAppBar({Key key})
      : super(
          key: key,
          title: Text("Make Goal"),
          centerTitle: true,
          elevation: 0.0,
          leading: MakeGoalBackButton(),
          bottom: PreferredSize(
            child: MakeGoalProgressBar(),
            preferredSize: const Size.fromHeight(8.0),
          ),
          actions: [
            MakeGoalPrevStepWidget(),
          ],
        );
}

class MakeGoalPrevStepWidget extends StatelessWidget {
  const MakeGoalPrevStepWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MakeGoalProgressBloc bloc =
        BlocProvider.of<MakeGoalProgressBloc>(context);
    return BlocBuilder(
      bloc: bloc,
      builder: (context, MakeGoalProgressSnapshot value) => GestureDetector(
        onTap: () {
          MakeGoalNavigationBloc navBloc =
              BlocProvider.of<MakeGoalNavigationBloc>(context);
          navBloc.dispatch(
            MakeGoalNavigationEvent(
              action: MakeGoalNavigationAction.goBack,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Text(
              value.progress > (1 / numOfMakeGoalPages) ? "이전" : "",
              style: DoitMainTheme.makeGoalHintTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class MakeGoalBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(
        'assets/images/backButton.png',
        height: 16,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

class MakeGoalProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Divider(
          color: Color(0xff282828),
          height: 4.0,
        ),
        BlocBuilder(
          bloc: BlocProvider.of<MakeGoalProgressBloc>(context),
          builder: (context, MakeGoalProgressSnapshot snapshot) {
            double deviceWidth = MediaQuery.of(context).size.width;
            return AnimatedContainer(
              width: deviceWidth * snapshot.progress,
              duration: Duration(milliseconds: 300),
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4d90fb),
                    Color(0xff771de4),
                  ],
                ),
              ),
              height: 8.0,
            );
          },
        ),
      ],
    );
  }
}
