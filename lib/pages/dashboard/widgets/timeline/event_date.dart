import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDate extends StatelessWidget {

  final DateTime date;
  final bool fullFormat;

  const EventDate({Key key, @required this.date, this.fullFormat = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('EEE dd/M', "FR");
    DateFormat fullDateFormat = DateFormat("'Le 'EEEE dd/MM/yyyy' à 'HH:mm'.'", "FR");
    String dateStr = fullFormat ? fullDateFormat.format(date) : dateFormat.format(date);
    return  Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Container(
          constraints: BoxConstraints(minWidth: 80),
          child: Text(
            dateStr,
            textAlign: fullFormat ? TextAlign.center : TextAlign.right,
            style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).textTheme.bodyText2.color),
          )),
    );
  }

}

class NoEventDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Container(
        constraints: BoxConstraints(minWidth: 80),
        child: SizedBox(),
      ),
    );
  }

}