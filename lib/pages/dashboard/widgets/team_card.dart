import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/team_classification_bloc.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';
import 'package:v34/repositories/repository.dart';

import '../../../commons/router.dart';

class TeamCard extends StatefulWidget {
  final Team team;
  final Club? club;
  final bool currentlyDisplayed;
  final double distance;
  final double cardHeight;
  TeamCard(
      {required this.team,
      required this.currentlyDisplayed,
      required this.distance,
      required this.club,
      this.cardHeight = 190});

  @override
  _TeamCardState createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  late TeamRankingBloc _classificationBloc;

  @override
  void initState() {
    super.initState();
    _classificationBloc = TeamRankingBloc(repository: RepositoryProvider.of<Repository>(context));
    if (widget.currentlyDisplayed) {
      _classificationBloc.add(LoadTeamRankingEvent(widget.team));
    }
  }

  @override
  void didUpdateWidget(TeamCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // !oldWidget.active -> to avoid several calls to the API when sliding
    // which can create a visual bug
    if (widget.currentlyDisplayed &&
        ((widget.team.clubCode != oldWidget.team.clubCode) || !oldWidget.currentlyDisplayed)) {
      _classificationBloc.add(LoadTeamRankingEvent(widget.team));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _classificationBloc.close();
  }

  Widget _noPodiumData() {
    return Expanded(child: Text("Aucune donnée", textAlign: TextAlign.center));
  }

  List<Widget> _getPodiumWidget(state) {
    if (state is TeamRankingLoadedState) {
      List<Widget> result = state.rankings
          .expand((classification) {
            return [
              Expanded(
                child: PodiumWidget(
                  showTrailing: true,
                  classification: classification,
                  highlightedTeamCode: state.highlightedTeamCode,
                  currentlyDisplayed: widget.currentlyDisplayed,
                ),
              ),
              VerticalDivider(thickness: 0.9, indent: 38, endIndent: 38)
            ];
          })
          .take(state.rankings.length * 2 - 1)
          .toList();
      if (result.isEmpty) result.add(_noPodiumData());
      return result;
    } else if (state is TeamRankingLoadingState) {
      return [Center(child: Loading(loaderType: LoaderType.THREE_BOUNCE))];
    } else {
      return [];
    }
  }

  Function? _onTap(TeamRankingState state) {
    if (state is TeamRankingLoadedState) {
      return () =>
          RouterFacade.push(context: context, builder: (_) => TeamDetailPage(team: widget.team, club: widget.club!));
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    var absDistance = widget.distance.abs() > 1 ? 1 : widget.distance.abs();
    final double cardBodyHeight = widget.cardHeight - 15;
    return BlocBuilder<TeamRankingBloc, TeamRankingState>(
      bloc: _classificationBloc,
      builder: (context, state) {
        return Transform.scale(
          scale: 1.0 - (absDistance > 0.15 ? 0.15 : absDistance),
          child: TitledCard(
            title: widget.team.name!,
            bodyPadding: EdgeInsets.only(bottom: 12),
            body: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 0.0),
              child: Container(
                height: cardBodyHeight - 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _getPodiumWidget(state),
                ),
              ),
            ),
            onTap: _onTap(state) as void Function()?,
          ),
        );
      },
    );
  }
}
