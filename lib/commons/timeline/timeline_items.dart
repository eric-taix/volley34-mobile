import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/commons/timeline/match_title.dart';
import 'package:v34/models/event.dart';

import 'event_details.dart';

const double CardMargin = 19.0;

void showEventDetails(BuildContext context, Event event) {
  Router.push(
      context: context, builder: (context) => EventDetails(event: event));
}

abstract class TimelineItemWidget extends StatelessWidget {
  TimelineItemWidget();

  Color color();

  factory TimelineItemWidget.from(Event event) {
    switch (event.type) {
      case EventType.Match:
        return _MatchTimelineItem(event);
      case EventType.Meeting:
        return _MeetingTimelineItem(event);
      case EventType.Tournament:
        return _TournamentTimelineItem(event);
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

abstract class _OtherTimelineItem extends TimelineItemWidget {
  final Event event;

  _OtherTimelineItem(this.event);

  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(children: [
      Text(
        event.name,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      _Place(event.place, event.date),
    ], onTap: () => showEventDetails(context, event));
  }
}

class _TournamentTimelineItem extends _OtherTimelineItem {
  _TournamentTimelineItem(Event event) : super(event);

  @override
  Color color() => Colors.green;
}

class _MeetingTimelineItem extends _OtherTimelineItem {
  _MeetingTimelineItem(Event event) : super(event);

  @override
  Color color() => Colors.blueAccent;
}

class _MatchTimelineItem extends TimelineItemWidget {
  final Event event;

  _MatchTimelineItem(this.event);

  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(children: <Widget>[
      MatchTitle(event: event),
      _Place(event.place, event.date)
    ], onTap: () => showEventDetails(context, event));
  }

  @override
  Color color() => Colors.red;
}

class _TimelineItemCard extends StatelessWidget {
  final List<Widget> children;
  final Function onTap;

  _TimelineItemCard({@required this.children, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: CardMargin),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12, bottom: 12, top: 12),
              child: Column(
                children: children,
              )),
        ));
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
              style: Theme.of(context).textTheme.bodyText1,
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
