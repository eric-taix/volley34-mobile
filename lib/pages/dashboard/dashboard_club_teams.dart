import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/models/team.dart';
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
  Repository _repository;
  List<Team> _teams = [];
  int _currentIndex = 0;

  @override
  void initState() {
    _repository = RepositoryProvider.of<Repository>(context);
    _pageController = PageController(
      viewportFraction: 0.8,
    )..addListener(() {
      var nextIndex = _pageController.page.round();
      setState(() => {});
      if (nextIndex != _currentIndex) {
        _currentIndex = nextIndex;
      }
    });
    _loadTeams(widget.clubCode);
    super.initState();
  }

  @override
  void didUpdateWidget(DashboardClubTeams oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadTeams(widget.clubCode);
  }

  _loadTeams(String clubCode) {
    _repository.loadClubTeams(clubCode).then((teams) {
      setState(() {
        _teams = teams;
        _pageController.jumpTo(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: widget.cardHeight,
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: _teams.length,
            itemBuilder: (context, index) {
              return TeamCard(
                currentlyDisplayed: _currentIndex == index,
                team: _teams[index],
                distance: _pageController.page - index,
              );
            },
          )
        ),
        if (_teams.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _teams.length,
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
  }

}
