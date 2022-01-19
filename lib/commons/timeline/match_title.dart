import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/force_teams.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/team.dart';

class MatchTitle extends StatelessWidget {
  final Event event;
  final Team team;
  final bool allowDetails;
  final bool showForces;
  const MatchTitle(
      {Key? key, required this.event, required this.team, required this.allowDetails, required this.showForces})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        allowDetails ? Theme.of(context).textTheme.bodyText2! : Theme.of(context).textTheme.bodyText1!;
    allowDetails ? Theme.of(context).textTheme.bodyText2! : Theme.of(context).textTheme.bodyText1!;
    return Column(
      children: [
        Text(
          event.hostName!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(fontWeight: team.code == event.hostCode ? FontWeight.bold : FontWeight.normal),
        ),
        BlocBuilder<PreferencesBloc, PreferencesState>(
          builder: (context, state) => showForces ||
                  (state is PreferencesUpdatedState && (state.showForceOnDashboard ?? false))
              ? ForceTeams(
                  forces: allowDetails ? event.forces : null,
                  hostCode: event.hostCode!,
                  visitorCode: event.visitorCode!,
                  receiveText: allowDetails ? "reçoit" : "a reçu",
                  showDivider: allowDetails,
                  backgroundColor: allowDetails ? Theme.of(context).cardTheme.color! : Theme.of(context).canvasColor,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                  child: Text("reçoit", style: Theme.of(context).textTheme.bodyText1),
                ),
        ),
        Text(
          event.visitorName!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(fontWeight: team.code == event.visitorCode ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
