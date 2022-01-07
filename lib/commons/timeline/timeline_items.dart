import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/commons/timeline/match_title.dart';
import 'package:v34/commons/timeline/postponed_badge.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/team.dart';

import 'event_details.dart';

const double CardMargin = 19.0;

void showEventDetails(BuildContext context, Event event) {
  RouterFacade.push(context: context, builder: (context) => EventDetails(event: event));
}

abstract class TimelineItemWidget extends StatelessWidget {
  TimelineItemWidget();

  Color? color();

  factory TimelineItemWidget.from(Event event, Team team, bool showForces) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    switch (event.type) {
      case EventType.Match:
        return _MatchTimelineItem(event, team, event.date!.compareTo(today) >= 0 || !event.hasResult, showForces);
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
  Color? color() => null;
}

abstract class _OtherTimelineItem extends TimelineItemWidget {
  final Event event;

  _OtherTimelineItem(this.event);

  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(children: [
      Text(
        event.name!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText2!,
      ),
      _Place(event.place, event.date, event.fullDay),
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
  final Team team;
  final bool allowDetails;
  final bool showForces;
  _MatchTimelineItem(this.event, this.team, this.allowDetails, this.showForces);

  @override
  Widget build(BuildContext context) {
    return _TimelineItemCard(
      children: <Widget>[
        MatchTitle(allowDetails: allowDetails, event: event, team: team, showForces: showForces),
        if (allowDetails) _Place(event.place, event.date, false)
      ],
      onTap: allowDetails ? () => showEventDetails(context, event) : null,
      topRightWidget: event.postponedDate != null ? PostponedBadge() : SizedBox(),
    );
  }

  @override
  Color color() => Colors.red;
}

class _TimelineItemCard extends StatelessWidget {
  final List<Widget> children;
  final Function? onTap;
  final Widget? topRightWidget;

  _TimelineItemCard({required this.children, this.onTap, this.topRightWidget});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: onTap != null ? null : 0,
      color: onTap != null ? Theme.of(context).cardTheme.color : Theme.of(context).canvasColor,
      shape: onTap != null
          ? null
          : RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).cardTheme.color!, width: 2),
              borderRadius: Theme.of(context).cardTheme.shape is RoundedRectangleBorder
                  ? (Theme.of(context).cardTheme.shape as RoundedRectangleBorder).borderRadius
                  : BorderRadius.circular(18),
            ),
      margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: CardMargin),
      child: InkWell(
        onTap: onTap != null ? () => onTap!() : null,
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12, top: 12),
              child: Column(
                children: children,
              ),
            ),
            if (topRightWidget != null) Positioned(child: topRightWidget!, top: 8, right: 8)
          ],
        ),
      ),
    );
  }
}

class _Place extends StatefulWidget {
  final String? place;
  final DateTime? dateTime;
  final bool? fullDay;

  _Place(this.place, this.dateTime, this.fullDay);

  @override
  State<_Place> createState() => _PlaceState();
}

class _PlaceState extends State<_Place> {
  final DateFormat _dateFormat = DateFormat('HH:mm', "FR");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${widget.fullDay ?? false ? "Toute la journée" : _dateFormat.format(widget.dateTime!)} - ${widget.place}",
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
