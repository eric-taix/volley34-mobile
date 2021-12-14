import 'package:flutter/material.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/team.dart';

class MatchTitle extends StatelessWidget {
  final Event event;
  final Team team;
  const MatchTitle({Key? key, required this.event, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                event.hostName!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("reçoit", style: Theme.of(context).textTheme.bodyText1),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  event.visitorName!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 4),
                /*  child: ForceComparison(
                  hostForce: event.hostForce ?? Force(),
                  visitorForce: event.visitorForce ?? Force(),
                  globalForce: event.globalForce ?? Force(),
                  direction: event.hostCode == team.code ? ForceDirection.rightToLeft : ForceDirection.leftToRight,
                ),*/
              ),
            ],
          ),
        ),
      ],
    );
  }
}
