import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDate extends StatelessWidget {
  static const double dateColumnWidth = 55;

  final DateTime? date;
  final DateTime? endDate;
  final bool fullFormat;
  final bool hour;
  final bool fullDay;

  final Widget Function(BuildContext, DateTime?, DateTime?)? dateBuilder;

  const EventDate({
    Key? key,
    required this.date,
    this.endDate,
    this.fullFormat = false,
    this.hour = false,
    this.fullDay = false,
    this.dateBuilder,
  }) : super(key: key);

  String _capitalize(String input) {
    return "${input[0].toUpperCase()}${input.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('EEE dd/M', "FR");
    DateFormat fullDateFormat = DateFormat("EEEE dd MMMM", "FR");
    DateFormat hourFormat = DateFormat("À HH:mm", "FR");
    DateFormat fromHourFormat = DateFormat("'De 'HH:mm ", "FR");
    DateFormat toHourFormat = DateFormat("'à 'HH:mm", "FR");
    String dateStr;
    if (hour) {
      if (fullDay) {
        dateStr = "Toute la journée";
      } else {
        dateStr =
            (endDate == null) ? hourFormat.format(date!) : fromHourFormat.format(date!) + toHourFormat.format(endDate!);
      }
    } else {
      dateStr = fullFormat ? fullDateFormat.format(date!) : dateFormat.format(date!);
    }
    dateStr = _capitalize(dateStr);
    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: Container(
        constraints: BoxConstraints(minWidth: dateColumnWidth, maxWidth: dateColumnWidth),
        child: Builder(
          builder: (context) => dateBuilder != null
              ? dateBuilder!(context, date, endDate)
              : Text(
                  dateStr,
                  textAlign: fullFormat || hour ? TextAlign.left : TextAlign.right,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).textTheme.bodyText2!.color),
                ),
        ),
      ),
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
