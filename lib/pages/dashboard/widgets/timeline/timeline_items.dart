import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/event.dart';
import 'package:v34/pages/dashboard/widgets/timeline/event_date.dart';
import 'package:v34/pages/dashboard/widgets/timeline/gymnasium_location.dart';
import 'package:v34/pages/dashboard/widgets/timeline/match_title.dart';

const double CardMargin = 19.0;

abstract class TimelineItemWidget extends StatelessWidget {
  TimelineItemWidget();

  Color color();

  factory TimelineItemWidget.from(Event event) {
    switch (event.type) {
      case EventType.Match:
        return _MatchTimelineItem(event);
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
          style: Theme.of(context).textTheme.bodyText2.copyWith(
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
            style: Theme.of(context).textTheme.bodyText2.copyWith(
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
  final Event event;
  _MatchTimelineItem(this.event);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _TimelineItemCard(
        children: <Widget>[
          MatchTitle(event: event),
          _Place(event.place, event.date)
        ],
      ),
      onTap: () => _showEventDetailsDialog(context),
    );
  }

  Future<void> _showEventDetailsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => _eventDetailsDialog(context),
    );
  }

  Widget _eventDetailsDialog(BuildContext context) {
    return SimpleDialog(
      title: MatchTitle(event: event),
      backgroundColor: Theme.of(context).cardTheme.color,
      elevation: 8.0,
      contentPadding: const EdgeInsets.all(10.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: EventDate(date: event.date, fullFormat: true),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text("Lieu : ${event.place}", textAlign: TextAlign.center),
        ),
        GymnasiumLocation(event: event)
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
