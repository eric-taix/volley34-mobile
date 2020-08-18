import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Event extends Equatable {
  // Common
  final DateTime date;
  final String place;
  final EventType type;

  // Match
  final String hostName;
  final String visitorName;

  // Others
  final String name;
  final String gymnasiumCode;

  Event(
      {this.date,
      this.name,
      this.place,
        this.gymnasiumCode,
      this.type,
      this.hostName,
      this.visitorName});

  factory Event.fromJson(json) {
    if (json["MatchCode"] != null) {
      return Event(
        date: DateTime.parse(json["DateMatch"]),
        name: json["CalendarEventName"] ?? json["LibelleMatch"],
        place: json["NomGymnase"],
        gymnasiumCode : json["GymnaseCode"],
        hostName: json["NomLocaux"],
        visitorName: json["NomVisiteurs"],
        type: EventType.Match,
      );
    } else {
      return Event(
        date: DateTime.parse(json["CalendarEventStartDate"]),
        name: json["CalendarEventName"],
        place: json["CalendarEventPlace"],
        type: _toEnumType(json["CalendarEventType"]),
      );
    }
  }

  static EventType _toEnumType(String enumType) {
    switch (enumType) {
      case "T":
        return EventType.Tournament;
      case "F":
        return EventType.Meeting;
      case "M":
        return EventType.Match;
      default:
        return EventType.Unknown;
    }
  }

  @override
  List<Object> get props => [name, date];

}

enum EventType { Match, Tournament, Meeting, Unknown }
