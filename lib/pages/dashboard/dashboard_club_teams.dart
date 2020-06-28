import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/pages/club-details/blocs/club_teams.bloc.dart';
import 'package:v34/pages/dashboard/team_card.dart';
import 'package:v34/repositories/repository.dart';

final Random random = Random.secure();

class DashboardClubTeams extends StatefulWidget {
  final String clubCode;
  final double cardHeight = 190;

  DashboardClubTeams({this.clubCode});

  @override
  _DashboardClubTeamsState createState() => _DashboardClubTeamsState();
}

class _DashboardClubTeamsState extends State<DashboardClubTeams> with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _currentIndex = 0;
  ClubTeamsBloc _clubTeamsBloc;

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: 0.8,
    )..addListener(() {
      var nextIndex = _pageController.page.round();
      setState(() => {});
      if (nextIndex != _currentIndex) {
        _currentIndex = nextIndex;
      }
    });
    _clubTeamsBloc = ClubTeamsBloc(
      repository: RepositoryProvider.of<Repository>(context),
    );
    _clubTeamsBloc.listen((state) {
      if (state is ClubTeamsLoaded && _pageController.hasClients) {
        _currentIndex = 0;
        _pageController.jumpTo(0);
      }
    });
    _clubTeamsBloc.add(ClubTeamsLoadEvent(clubCode: widget.clubCode));
    super.initState();
  }

  @override
  void didUpdateWidget(DashboardClubTeams oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clubCode != oldWidget.clubCode) {
      _clubTeamsBloc.add(ClubTeamsLoadEvent(clubCode: widget.clubCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClubTeamsBloc, ClubTeamsState>(
      bloc: _clubTeamsBloc,
      builder: (context, state) {
        if (state is ClubTeamsLoaded) {
          return Column(
              children: <Widget>[
                Container(
                    height: widget.cardHeight,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _pageController,
                      itemCount: state.teams.length,
                      itemBuilder: (context, index) {
                        return TeamCard(
                          currentlyDisplayed: _currentIndex == index,
                          team: state.teams[index],
                          distance: (_currentIndex - index).toDouble(),
                        );
                      },
                    )
                ),
                if (state.teams.length > 1)
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: SmoothPageIndicator(
                        controller: _pageController,
                        count: state.teams.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          dotColor: Theme.of(context).cardTheme.color,
                          activeDotColor: Theme.of(context).accentColor,
                        )
                    ),
                  )
              ]
          );
        } else {
          return Container(height: widget.cardHeight);
        }
      },
    );
  }

}
