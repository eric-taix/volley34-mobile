import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/event.dart';

const double CardMargin = 19.0;

abstract class TimelineItemWidget extends StatelessWidget {
  TimelineItemWidget();

  Color color();

  factory TimelineItemWidget.from(Event event) {
    switch (event.type) {
      case EventType.Match:
        return _MatchTimelineItem(
            event.hostName, event.visitorName, event.place, event.date);
      case EventType.Meeting:
        return _MeetingTimelineItem(event.name, event.place, event.date);
      case EventType.Tournament:
        return _TournamentTimelineItem(event.name, event.place, event.date);
      default:
        return _UnknownTimelineItem();
    }
  }
}

class _UnknownTimelineItem extends TimelineItemWidget {
  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(children: [Text("Unknown event")]);
  }

  @override
  Color color() => null;
}

class _TournamentTimelineItem extends TimelineItemWidget {
  final String title;
  final String place;
  final DateTime dateTime;

  _TournamentTimelineItem(this.title, this.place, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        _Place(place, dateTime),
      ],
    );
  }

  @override
  Color color() => Colors.green;
}

class _MeetingTimelineItem extends TimelineItemWidget {
  final String title;
  final String place;
  final DateTime dateTime;

  _MeetingTimelineItem(this.title, this.place, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _Place(place, dateTime),
      ],
    );
  }

  @override
  Color color() => Colors.blueAccent;
}

class _MatchTimelineItem extends TimelineItemWidget {
  final String host;
  final String visitor;
  final String place;
  final DateTime dateTime;
  _MatchTimelineItem(this.host, this.visitor, this.place, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(
      children: <Widget>[
        Text(
          host,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text("reçoit", style: Theme.of(context).textTheme.body2),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            visitor,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _Place(place, dateTime)
      ],
    );
  }

  @override
  Color color() => Colors.red;
}

class _TimelineItemCard extends StatelessWidget {
  final List<Widget> children;

  _TimelineItemCard({this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
        margin: EdgeInsets.only(
            left: 0, right: 0, top: 0, bottom: CardMargin),
        child: Padding(
            padding: const EdgeInsets.only(
                left: 12.0, right: 12, bottom: 12, top: 12),
            child: Column(
              children: children,
            )));
  }
}

class _Place extends StatelessWidget {
  final String place;
  final DateTime dateTime;

  final DateFormat _dateFormat = DateFormat('HH:mm', "FR");


  _Place(this.place, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${_dateFormat.format(dateTime)} - $place",
              style: Theme.of(context).textTheme.body2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
