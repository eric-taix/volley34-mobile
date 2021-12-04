import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'details/event_date.dart';
import 'line.dart';

const double circleRadius = 8.0;
const double lineWidth = 2.0;
const double circleLineWidth = 3.0;

class Timeline extends StatelessWidget {
  final List<TimelineItem> items;

  final TimelineGapBuilder gapBuilder = TimelineGapBuilder(Duration(days: 7));

  Timeline(this.items);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 18),
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            ...items.expand((item) {
              return [
                gapBuilder.createGapIfHigherThanMinDuration(item.date),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: EventDate(
                            date: item.date,
                            dateBuilder: (context, _, __) {
                              DateFormat dateFormat = DateFormat('EEE dd/M', "FR");
                              List<String> dateStr = dateFormat.format(item.date!).split(" ");
                              List<String> daysStr = dateStr[1].split("/");
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "${dateStr[0][0].toUpperCase()}${dateStr[0].substring(1)}",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: daysStr[0],
                                      style: Theme.of(context).textTheme.headline4,
                                      children: [
                                        TextSpan(
                                          text: " / ${daysStr[1]}",
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Line(
                          circleRadius: circleRadius,
                          lineWidth: lineWidth,
                          circleLineWidth: circleLineWidth,
                          circleColor: item.events!.first.color,
                        ),
                      ),
                      Expanded(child: item.events!.first.child!),
                    ],
                  ),
                ),
                ...item.events!.skip(1).map((event) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NoEventDate(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Line(
                            circleRadius: circleRadius,
                            lineWidth: lineWidth,
                            circleLineWidth: circleLineWidth,
                            circleColor: item.events!.first.color,
                          ),
                        ),
                        Expanded(child: event.child!),
                      ],
                    ),
                  );
                }),
              ];
            })
          ],
        ));
  }
}

class TimelineGapBuilder {
  DateTime? previousDate;
  final Duration minGapDuration;

  TimelineGapBuilder(this.minGapDuration);

  Widget createGapIfHigherThanMinDuration(DateTime? dateTime) {
    if (previousDate == null || dateTime!.difference(previousDate!) > minGapDuration) {
      previousDate = dateTime;
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 4.0),
              child: Container(
                  constraints: BoxConstraints(
                    minWidth: EventDate.dateColumnWidth,
                    maxWidth: EventDate.dateColumnWidth,
                  ),
                  child: SizedBox(height: 50, width: EventDate.dateColumnWidth)),
            ),
            DashedLine(lineWidth),
            Expanded(child: SizedBox()),
          ],
        ),
      );
    }
    previousDate = dateTime;
    return SizedBox();
  }
}

class TimelineItem {
  final DateTime? date;
  final List<TimelineEvent>? events;

  TimelineItem({this.date, this.events});
}

class TimelineEvent {
  final Widget? child;
  final Color? color;

  TimelineEvent({this.child, this.color});
}
