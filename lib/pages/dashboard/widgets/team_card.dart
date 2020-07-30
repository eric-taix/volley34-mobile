import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/team_classification_bloc.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';
import 'package:v34/repositories/repository.dart';

class TeamCard extends StatefulWidget {
  final Team team;
  final bool currentlyDisplayed;
  final double distance;
  final Function() onFavoriteChange;
  final double cardHeight = 190;

  TeamCard({@required this.team, @required this.currentlyDisplayed, @required this.distance, this.onFavoriteChange});

  @override
  _TeamCardState createState() => _TeamCardState();

}

class _TeamCardState extends State<TeamCard> {
  TeamClassificationBloc _classificationBloc;

  @override
  void initState() {
    super.initState();
    _classificationBloc = TeamClassificationBloc(
      repository: RepositoryProvider.of<Repository>(context)
    );
    if (widget.currentlyDisplayed) {
      _classificationBloc.add(LoadTeamClassificationEvent(widget.team));
    }
  }

  @override
  void didUpdateWidget(TeamCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // !oldWidget.active -> to avoid several calls to the API when sliding
    // which can create a visual bug
    if (widget.currentlyDisplayed && ((widget.team.clubCode != oldWidget.team.clubCode) || !oldWidget.currentlyDisplayed)) {
      _classificationBloc.add(LoadTeamClassificationEvent(widget.team));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _classificationBloc.close();
  }

  Widget _noPodiumData() {
    return Expanded(
      child: Text(
        "Aucune donnée",
        textAlign: TextAlign.center
      )
    );
  }

  List<Widget> _getPodiumWidget(state) {
    if (state is TeamClassificationLoadedState) {
      List<Widget> result = state.classifications.map((classification) {
        return Expanded(
          child: PodiumWidget(
            classification: classification,
            highlightedTeamCode: state.highlightedTeamCode,
            currentlyDisplayed: widget.currentlyDisplayed,
          ),
        );
      }).toList();
      if (result.isEmpty) result.add(_noPodiumData());
      return result;
    } else if (state is TeamClassificationLoadingState) {
      return [Expanded(child: Loading(loaderType: LoaderType.THREE_BOUNCE))];
    } else {
      return [];
    }
  }

  Function _onTap(TeamClassificationState state) {
    if (state is TeamClassificationLoadedState) {
      return () => Router.push(context: context, builder: (_) => TeamDetailPage(team: widget.team, classifications: state.classifications)).then(
        (_) => widget.onFavoriteChange()
      );
    }
    else return null;
  }

  @override
  Widget build(BuildContext context) {
    var absDistance = widget.distance.abs() > 1 ? 1 : widget.distance.abs();
    final double cardBodyHeight = widget.cardHeight - 20;
    return BlocBuilder<TeamClassificationBloc, TeamClassificationState>(
      bloc: _classificationBloc,
      builder: (context, state) {
        return Transform.scale(
          scale: 1.0 - (absDistance > 0.15 ? 0.15 : absDistance),
          child: TitledCard(
            title: widget.team.name,
            bodyPadding: EdgeInsets.zero,
            body: Container(
              height: cardBodyHeight,
              child: Row(children: _getPodiumWidget(state)),
            ),
            onTap: _onTap(state),
          ),
        );
      },
    );
  }

}