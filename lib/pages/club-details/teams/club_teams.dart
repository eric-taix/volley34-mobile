import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/blocs/club_teams.bloc.dart';
import 'package:v34/pages/club-details/teams/club_team.dart';
import 'package:v34/repositories/repository.dart';

class ClubTeams extends StatefulWidget {
  final Club club;

  ClubTeams(this.club);

  @override
  _ClubTeamsState createState() => _ClubTeamsState();
}

class _ClubTeamsState extends State<ClubTeams> {
  ClubTeamsBloc? _clubTeamsBloc;

  @override
  void initState() {
    super.initState();
    _clubTeamsBloc = ClubTeamsBloc(repository: RepositoryProvider.of<Repository>(context))
      ..add(ClubTeamsLoadEvent(widget.club.code));
  }

  @override
  void dispose() {
    _clubTeamsBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _clubTeamsBloc,
      builder: (context, dynamic state) {
        return (state is ClubTeamsLoaded)
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ClubTeam(
                      team: state.teams![index],
                      club: widget.club,
                    );
                  },
                  childCount: state.teams!.length,
                ),
              )
            : SliverFillRemaining(child: Center(child: Loading()));
      },
    );
  }
}
