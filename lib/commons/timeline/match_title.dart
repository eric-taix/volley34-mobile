import 'package:flutter/material.dart';
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
        ForceTeams(
          hostForce: allowDetails ? event.hostForce : null,
          visitorForce: allowDetails ? event.visitorForce : null,
          globalForce: event.globalForce,
          receiveText: allowDetails ? "reçoit" : "a reçu",
          showDivider: allowDetails,
          backgroundColor: allowDetails ? Theme.of(context).cardTheme.color! : Theme.of(context).canvasColor,
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
