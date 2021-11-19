import 'package:flutter/material.dart';
import 'package:v34/models/event.dart';

class MatchTitle extends StatelessWidget {
  final Event event;

  const MatchTitle({Key? key, required this.event}) : super(key: key);

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
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

}