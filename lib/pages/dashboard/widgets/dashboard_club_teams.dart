import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/widgets/team_card.dart';

typedef TeamFavoriteChangeCallback = void Function(Team team);

class DashboardClubTeam extends StatelessWidget {
  final Team team;
  final Club club;
  static final double cardHeight = 320;

  const DashboardClubTeam({Key? key, required this.team, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 0),
        child: TeamCard(
          cardHeight: cardHeight,
          currentlyDisplayed: true,
          team: team,
          club: club,
          distance: 0,
        ),
      ),
    );
  }
}
