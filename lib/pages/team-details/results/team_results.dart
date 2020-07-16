import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/results/result_card.dart';
import 'package:v34/repositories/repository.dart';

class TeamResults extends StatefulWidget {
  final Team team;

  const TeamResults({Key key, @required this.team}) : super(key: key);

  @override
  _TeamResultsState createState() => _TeamResultsState();

}

class _TeamResultsState extends State<TeamResults> {
  TeamBloc _teamBloc;
  
  @override
  void initState() {
    super.initState();
    _teamBloc = TeamBloc(repository: RepositoryProvider.of<Repository>(context));
    _teamBloc.add(TeamLoadResults(code: widget.team.code, last: 50));
  }

  Widget _buildChampionshipResults(TeamResultsLoaded state) {
    List<Widget> items = [];
    for (MatchResult result in state.results) {
      Widget element = ResultCard(teamCode: widget.team.code, result: result);
      items.add(element);
    }
    return Column(
      children: items
    );
  }

  Widget _buildChallengeResults(TeamResultsLoaded state) {
    return Container();
  }

  Widget _buildSpringCupResults(TeamResultsLoaded state) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      bloc: _teamBloc,
      builder: (context, state) {
        if (state is TeamResultsLoaded) {
          state.results.sort((res1, res2) => res2.inputDate.compareTo(res1.inputDate));
          return SliverList(
            delegate: SliverChildListDelegate([
              _buildChampionshipResults(state),
              _buildChallengeResults(state),
              _buildSpringCupResults(state)
            ]),
          );
        } else {
          return SliverList(
            delegate: SliverChildListDelegate([])
          );
        }
      },
    );
  }
}