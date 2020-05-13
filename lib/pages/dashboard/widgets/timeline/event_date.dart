

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDate extends StatelessWidget {

  final DateFormat _dateFormat = DateFormat('EEE dd/M', "FR");
  final DateTime date;

  EventDate(this.date);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Container(
          constraints: BoxConstraints(minWidth: 80),
          child: Text(
            _dateFormat.format(date),
            textAlign: TextAlign.right,
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