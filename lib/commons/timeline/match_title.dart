import 'package:flutter/material.dart';
import 'package:v34/commons/force_teams.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/team.dart';

class MatchTitle extends StatelessWidget {
  final Event event;
  final Team team;
  const MatchTitle({Key? key, required this.event, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          event.hostName!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        ForceTeams(
          hostForce: event.hostForce,
          visitorForce: event.visitorForce,
          globalForce: event.globalForce,
        ),
        Text(
          event.visitorName!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
