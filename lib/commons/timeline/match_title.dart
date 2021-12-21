import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/force_widget.dart';
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
        ForceWidget(
          force: event.hostForce!,
          globalForce: event.globalForce!,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              SvgPicture.asset("assets/attack.svg", width: 24, color: Theme.of(context).textTheme.bodyText1!.color),
              Expanded(
                  child: Stack(
                children: [
                  Divider(indent: 20, endIndent: 20),
                  Center(
                    child: Container(
                      color: Theme.of(context).cardTheme.color,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("reçoit", style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                  ),
                ],
              )),
              SvgPicture.asset("assets/defense.svg", width: 24, color: Theme.of(context).textTheme.bodyText1!.color),
            ],
          ),
        ),
        SizedBox(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            event.visitorName!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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
    );
  }
}
