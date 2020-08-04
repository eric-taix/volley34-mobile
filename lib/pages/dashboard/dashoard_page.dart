import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_teams.bloc.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_agenda.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_club_teams.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_clubs.dart';
import 'package:v34/repositories/repository.dart';

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Club _currentClub;
  ClubTeamsBloc _clubTeamsBloc;

  @override
  void initState() {
    _clubTeamsBloc = ClubTeamsBloc(
      repository: RepositoryProvider.of<Repository>(context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: "Volley34",
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Paragraph(title: "Vos clubs"),
          DashboardClubs(key: ValueKey("dashboard-clubs"), onClubChange: (club) => _selectCurrentClub(club)),
          Paragraph(title: "Vos équipes"),
          if (_currentClub != null) _buildDashboardElement(_teamsElement),
          Paragraph(title: "Votre agenda"),
          if (_currentClub != null) _buildDashboardElement(_agendaElement)
        ])
      )
    );
  }

  Widget _teamsElement(List<Team> teams) {
    if (teams.length > 0) {
      return DashboardClubTeams(teams: teams, onFavoriteTeamsChange: () => _selectCurrentClub(_currentClub));
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: RaisedButton(
            onPressed: () =>  Router.push(context: context, builder: (_) => ClubDetailPage(_currentClub)).then(
              (_) => _selectCurrentClub(_currentClub),
            ),
            padding: EdgeInsets.all(12.0),
            child: Text("Sélectionnez une équipe favorite")
          ),
        ),
      );
    }
  }

  Widget _agendaElement(List<Team> teams) {
    return DashboardAgenda(teams: teams);
  }

  Widget _buildDashboardElement(Function toBuild) {
    return BlocBuilder<ClubTeamsBloc, ClubTeamsState>(
      bloc: _clubTeamsBloc,
      builder: (context, state) {
        if (state is ClubTeamsLoaded) {
          return toBuild(state.teams);
        } else return Container(height: 250, child: Loading());
      }
    );
  }

  void _selectCurrentClub(Club club) {
    setState(() => _currentClub = club);
    _clubTeamsBloc.add(ClubFavoriteTeamsLoadEvent(club.code));
  }

}
