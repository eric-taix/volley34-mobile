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
  const MatchTitle({Key? key, required this.event, required this.team, required this.allowDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = allowDetails
        ? Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold);
    return Column(
      children: [
        Text(
          event.hostName!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        BlocBuilder<PreferencesBloc, PreferencesState>(
          builder: (context, state) => state is PreferencesUpdatedState && (state.showForceOnDashboard ?? false)
              ? ForceTeams(
                  hostForce: allowDetails ? event.hostForce : null,
                  visitorForce: allowDetails ? event.visitorForce : null,
                  globalForce: event.globalForce,
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
          style: textStyle,
        ),
      ],
    );
  }
}
