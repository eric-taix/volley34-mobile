import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:v34/models/event.dart';
import 'package:v34/utils/launch.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as addToCalendar;

import 'organizer_club.dart';
import 'event_date.dart';
import 'event_place.dart';
import '../match_title.dart';

class EventInfo extends StatelessWidget {

  final Event event;
  final double _iconSize = 30.0;

  const EventInfo({Key key, @required this.event}) : super(key: key);

  Widget _buildDate(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        color: Theme.of(context).accentColor,
        size: _iconSize,
      ),
      subtitle: Container(
        padding: const EdgeInsets.only(top: 8.0),
        child: OutlineButton.icon(
          onPressed: () => _addEventToCalendar(),
          icon: Icon(Icons.add, color: Theme.of(context).accentColor.withOpacity(0.5)),
          label: Text("Ajouter à l'agenda"),
          borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
        ),
      ),
      title: EventDate(date: event.date, endDate: event.endDate, fullFormat: true),
    );
  }

  Widget _buildHour(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.access_time,
        color: Theme.of(context).accentColor,
        size: _iconSize,
      ),
      title: EventDate(date: event.date, endDate: event.endDate, hour: true),
    );
  }

  Widget _buildPlace(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.location_on,
        color: Theme.of(context).accentColor,
        size: _iconSize,
      ),
      subtitle: EventPlace(event: event),
      title: Text(
        event.place,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).textTheme.bodyText2.color)
      ),
    );
  }

  Widget _buildOrganizerClub(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset('assets/shield.svg', width: _iconSize, height: _iconSize, color: Theme.of(context).accentColor),
      title: OrganizerClub(clubCode: event.clubCode),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.description,
        color: Theme.of(context).accentColor,
        size: _iconSize,
      ),
      title: HtmlWidget(event.description, textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).textTheme.bodyText2.color))
    );
  }

  Widget _buildContact(BuildContext context) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: event.contactEmail,
      query: 'subject=${event.name}',
    );
    Widget subtitle;
    if (event.contactPhone != null || event.contactEmail != null) {
      subtitle = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (event.contactPhone != null) OutlineButton.icon(
              icon: Icon(Icons.phone, color: Theme.of(context).accentColor.withOpacity(0.5)),
              onPressed: () => launchURL("tel:${event.contactPhone}"),
              label: Text("Appeler"),
              borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
            ),
            if (event.contactEmail != null) OutlineButton.icon(
              icon: Icon(Icons.mail, color: Theme.of(context).accentColor.withOpacity(0.5)),
              onPressed: () => launchURL(params.toString()),
              label: Text("Envoyer un mail"),
              borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
            )
          ],
        ),
      );
    }
    return ListTile(
      leading: Icon(
        Icons.person,
        color: Theme.of(context).accentColor,
        size: _iconSize,
      ),
      title: Text(
        event.contactName,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).textTheme.bodyText2.color)
      ),
      subtitle: subtitle,
    );
  }

  void _addEventToCalendar() async {
    final addToCalendar.Event event = addToCalendar.Event(
        title: this.event.name,
        location: this.event.place,
        startDate: this.event.date,
        endDate: this.event.endDate ?? this.event.date.add(Duration(hours: 2))
    );
    await addToCalendar.Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          if (event.type == EventType.Match) Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: MatchTitle(event: event),
          ),
          if (event.type == EventType.Match) Divider(color: Theme.of(context).accentColor.withOpacity(0.1)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildDate(context),
          ),
          Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildHour(context),
          ),
          Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildPlace(context),
          ),
          Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
          if (event.clubCode != null) Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildOrganizerClub(context),
          ),
          if (event.clubCode != null) Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
          if (event.description != null) Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildDescription(context),
          ),
          if (event.description != null) Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
          if (event.contactName != null) Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildContact(context)
          ),
          if (event.contactName != null) Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
        ]
      )
    );
  }

}