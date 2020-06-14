import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/podium.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/team.dart';
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
  String _highlightedTeamCode;
  List<ClassificationSynthesis> _competitionsClassificationSynthesis = [];

  @override
  void initState() {
    _repository = RepositoryProvider.of<Repository>(context);
    _pageController = PageController(
      viewportFraction: 0.8,
    )..addListener(() {
        var nextIndex = _pageController.page.round();
        setState(() {});
        if (nextIndex != _currentIndex) {
          _currentIndex = nextIndex;
          _loadTeamClassification(_teams[nextIndex].code);
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
        _loadTeamClassification(_teams[0].code);
      });
    });
  }

  _loadTeamClassification(String teamCode) {
    print("====> TeamClass:$teamCode");
    _repository.loadTeamClassificationSynthesis(teamCode).then((List<ClassificationSynthesis> classifications) {
      setState(() {
        _competitionsClassificationSynthesis = classifications.map((classification) {
          classification.teamsClassifications.sort((tc1, tc2) {
            return tc1.rank.compareTo(tc2.rank) * -1;
          });
          return classification;
        }).toList();
        _highlightedTeamCode = teamCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.cardHeight,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: _teams.length,
        itemBuilder: (context, index) {
          var active = _currentIndex == index;
          return _buildTeamCard(active, _teams[index], _pageController.page - index);
        },
      ),
    );
  }

  Widget _buildTeamCard(bool active, Team team, double distance) {
    var absDistance = distance.abs() > 1 ? 1 : distance.abs();
    final double cardBodyHeight = widget.cardHeight - 40;
    return Transform.scale(
      scale: 1.0 - (absDistance > 0.15 ? 0.15 : absDistance),
      child: TitledCard(
        margin: EdgeInsets.zero,
        title: team.name,
        bodyPadding: EdgeInsets.zero,
        body: Container(
          height: cardBodyHeight,
          child: Row(children: [
            ..._competitionsClassificationSynthesis.map((competitionClassificationSynthesis) {
              var placeValues = competitionClassificationSynthesis.teamsClassifications.map((teamClassification) {
                return PlaceValue(teamClassification.teamCode, teamClassification.totalPoints.toDouble());
              }).toList();
              var highlightedIndex = placeValues.indexWhere((placeValue) => placeValue.id == _highlightedTeamCode);
              return Expanded(
                child: Podium(
                  placeValues,
                  active: active,
                  title: competitionClassificationSynthesis.label,
                  highlightedIndex: highlightedIndex,
                  promoted: competitionClassificationSynthesis.promoted,
                  relegated: competitionClassificationSynthesis.relegated,
                ),
              );
            })
          ]),
        ),
      ),
    );
  }
}
