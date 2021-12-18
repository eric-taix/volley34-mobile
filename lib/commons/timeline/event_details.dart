import 'package:flutter/material.dart';
import 'package:v34/commons/timeline/details/event_info.dart';
import 'package:v34/models/event.dart';
import 'package:v34/utils/analytics.dart';

class EventDetails extends StatefulWidget {
  final Event event;

  const EventDetails({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with RouteAwareAnalytics {
  @override
  void initState() {
    super.initState();
  }

  Widget _screenTitle(BuildContext context) {
    String title;
    switch (widget.event.type) {
      case EventType.Match:
        title = "Match";
        break;
      case EventType.Tournament:
        title = "Tournoi";
        break;
      case EventType.Meeting:
        title = "Evénement";
        break;
      default:
        title = "Inconnu";
        break;
    }
    return Text(title, textAlign: TextAlign.center, style: Theme.of(context).appBarTheme.titleTextStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                elevation: 0,
                title: _screenTitle(context),
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: true,
                ),
              ),
            ];
          },
          body: EventInfo(event: widget.event),
        ),
      ),
    );
  }

  @override
  AnalyticsRoute get route {
    switch (widget.event.type) {
      case EventType.Match:
        return AnalyticsRoute.match;
      case EventType.Tournament:
        return AnalyticsRoute.tournament;
      case EventType.Meeting:
        return AnalyticsRoute.meeting;
      case EventType.Unknown:
        return AnalyticsRoute.unknown_event;
      default:
        return AnalyticsRoute.unknown_event;
    }
  }
}
