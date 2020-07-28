import 'package:flutter/material.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/models/club.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_agenda.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_club_teams.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_clubs.dart';

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Club _currentClub;

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: "Volley34",
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Paragraph(title: "Vos clubs"),
          DashboardClubs(onClubChange: (club) => _selectCurrentClub(club)),
          Paragraph(title: "Vos équipes"),
          if (_currentClub != null) DashboardClubTeams(club: _currentClub, onTeamFavoriteChange: (_) => _selectCurrentClub(_currentClub)),
          Paragraph(title: "Votre agenda"),
          DashboardAgenda()
        ])
      )
    );
  }

  void _selectCurrentClub(Club club) {
    setState(() => _currentClub = club);
  }
}
