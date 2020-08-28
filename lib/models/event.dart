import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Event extends Equatable {
  // Common
  final DateTime date;
  final String place;
  final EventType type;
  final String name;

  // Match
  final String hostName;
  final String visitorName;
  final String gymnasiumCode;

  // Tournament & Meeting
  final DateTime endDate;
  final String contactName, contactPhone, contactEmail;
  final String description;
  final String clubCode;

  final String imageUrl;

  Event(
      {this.date,
      this.name,
      this.place,
      this.gymnasiumCode,
      this.type,
      this.hostName,
      this.visitorName,
      this.endDate,
      this.contactName,
      this.contactPhone,
      this.contactEmail,
      this.clubCode,
      this.description,
      this.imageUrl});

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
        endDate: DateTime.parse(json["CalendarEventEndDate"]),
        description: json["CalendarEventDesciption"],
        clubCode: json["CodeClub"],
        contactName: json["CalendarEventContactName"],
        contactPhone: json["CalendarEventContactPhone"],
        contactEmail: json["CalendarEventContactEmail"],
        imageUrl: json["CalendarEventImageURL"],
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
