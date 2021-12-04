import 'package:flutter/material.dart';
import 'package:v34/commons/force_widget.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/force.dart';

class MatchTitle extends StatelessWidget {
  final Event event;

  const MatchTitle({Key? key, required this.event}) : super(key: key);

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
                padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                child: ForceWidget(
                  hostName: "Hôte",
                  visitorName: "Visiteur",
                  hostForce: event.hostForce ?? Force(),
                  visitorForce: event.visitorForce ?? Force(),
                  globalForce: event.globalForce ?? Force(),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(child: Text("${event.hostForce?.homeAttackPerSet ?? 0}")),
                    Expanded(child: Text("${event.visitorForce?.outsideAttackPerSet ?? 0}")),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(child: Text("${event.hostForce?.homeDefensePerSet ?? 0}")),
                    Expanded(child: Text("${event.visitorForce?.outsideDefensePerSet ?? 0}")),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(child: Text("${event.globalForce?.homeAttackPerSet ?? 0}")),
                    Expanded(child: Text("${event.globalForce?.outsideAttackPerSet ?? 0}")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
