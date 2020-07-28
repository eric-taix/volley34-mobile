import 'package:flutter/material.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/models/club.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_agenda.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_club_teams.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_clubs.dart';

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Club _currentClub;
  List<Team> _currentTeams;

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: "Volley34",
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Paragraph(title: "Vos clubs"),
          DashboardClubs(onClubChange: (club) => _selectCurrentClub(club)),
          Paragraph(title: "Vos équipes"),
          if (_currentClub != null) DashboardClubTeams(
            key: ValueKey("dashboard-club-teams-${hashList(_currentTeams)}"),
            club: _currentClub,
            onTeamsChange: (teams) => _selectCurrentTeams(teams),
          ),
          Paragraph(title: "Votre agenda"),
          if(_currentTeams != null) DashboardAgenda(teams: _currentTeams)
        ])
      )
    );
  }

  void _selectCurrentClub(Club club) {
    setState(() {
      _currentClub = club;
      _currentTeams = null;
    });
  }

  void _selectCurrentTeams(List<Team> teams) {
    setState(() => _currentTeams = teams);
  }
}
