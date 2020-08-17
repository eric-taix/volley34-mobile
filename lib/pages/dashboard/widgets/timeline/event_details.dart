import 'package:flutter/material.dart';
import 'package:v34/models/event.dart';

import 'event_date.dart';
import 'gymnasium_location.dart';
import 'match_title.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  const EventDetails({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text("Détails du match")),
      body: _buildEventDetails(context)
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: MatchTitle(event: event),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: EventDate(date: event.date, fullFormat: true),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text("Lieu : ${event.place}", textAlign: TextAlign.center),
          ),
          GymnasiumLocation(event: event)
        ]
      )
    );
  }

}