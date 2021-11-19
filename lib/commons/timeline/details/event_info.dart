import 'package:add_2_calendar/add_2_calendar.dart' as addToCalendar;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:v34/commons/timeline/details/event_place.dart';
import 'package:v34/models/event.dart';
import 'package:v34/utils/launch.dart';

import 'event_date.dart';
import 'organizer_club.dart';

class EventInfo extends StatelessWidget {
  final Event event;
  final double _iconSize = 30.0;

  const EventInfo({Key? key, required this.event}) : super(key: key);

  List<Widget> _buildDateAndHour(BuildContext context) {
    return [
      ListTile(
          leading: Icon(
            Icons.date_range,
            color: Theme.of(context).accentColor,
            size: _iconSize,
          ),
          title: EventDate(
              date: event.date, endDate: event.endDate, fullFormat: true)),
      ListTile(
          leading: Icon(Icons.access_time,
              color: Theme.of(context).accentColor, size: _iconSize),
          title:
              EventDate(date: event.date, endDate: event.endDate, hour: true)),
      ListTile(
          title: Center(
        child: RaisedButton.icon(
          onPressed: () => _addEventToCalendar(),
          icon: Icon(
            Icons.calendar_today,
          ),
          label: Text("Ajouter à l'agenda"),
        ),
      ))
    ];
  }

  List<Widget> _buildPlace(BuildContext context) {
    return [
      ListTile(
        leading: Icon(
          Icons.location_on,
          color: Theme.of(context).accentColor,
          size: _iconSize,
        ),
        title: Text(event.place!,
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).textTheme.bodyText2!.color)),
      )
    ];
  }

  Widget _buildOrganizerClub(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset('assets/shield.svg',
          width: _iconSize,
          height: _iconSize,
          color: Theme.of(context).accentColor),
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
        title: HtmlWidget(event.description!,
            textStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).textTheme.bodyText2!.color)));
  }

  Widget _buildContact(BuildContext context) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: event.contactEmail,
      query: 'subject=${event.name}',
    );
    Widget? subtitle;
    if (event.contactPhone != null || event.contactEmail != null) {
      subtitle = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (event.contactPhone != null)
              RaisedButton.icon(
                icon: Icon(Icons.phone,
                    color: Theme.of(context).accentColor.withOpacity(0.5)),
                onPressed: () => launchURL("tel:${event.contactPhone}"),
                label: Text("Appeler"),
              ),
            if (event.contactEmail != null)
              RaisedButton.icon(
                icon: Icon(Icons.mail,
                    color: Theme.of(context).accentColor.withOpacity(0.5)),
                onPressed: () => launchURL(params.toString()),
                label: Text("Envoyer un mail"),
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
      title: Text(event.contactName!,
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Theme.of(context).textTheme.bodyText2!.color)),
      subtitle: subtitle,
    );
  }

  void _addEventToCalendar() async {
    final addToCalendar.Event event = addToCalendar.Event(
        title: this.event.name!,
        location: this.event.place!,
        startDate: this.event.date!,
        endDate: this.event.endDate ?? this.event.date!.add(Duration(hours: 2)));
    await addToCalendar.Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ..._buildDateAndHour(context),
          Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
          ..._buildPlace(context),
          EventPlace(event: event),
          if (event.clubCode != null) ...[
            Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _buildOrganizerClub(context),
            ),
          ],
          if (event.description != null) ...[
            Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _buildDescription(context),
            ),
          ],
          if (event.contactName != null) ...[
            Divider(color: Theme.of(context).accentColor.withOpacity(0.2)),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: _buildContact(context)),
          ],
        ],
      ),
    );
  }
}
