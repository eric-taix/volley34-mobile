import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:v34/models/force.dart';

@immutable
class Event extends Equatable {
  // Common
  final DateTime? date;
  final String? place;
  final EventType? type;
  final String? name;

  // Match
  final String? hostName;
  final String? hostCode;
  final String? visitorName;
  final String? visitorCode;
  final String? gymnasiumCode;
  final Force? hostForce;
  final Force? visitorForce;
  final Force? globalForce;
  final String? matchCode;

  // Tournament & Meeting
  final DateTime? endDate;
  final String? contactName, contactPhone, contactEmail;
  final String? description;
  final String? clubCode;

  final String? imageUrl;

  Event({
    this.date,
    this.name,
    this.place,
    this.gymnasiumCode,
    this.type,
    this.hostName,
    this.hostCode,
    this.visitorName,
    this.visitorCode,
    this.endDate,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.clubCode,
    this.description,
    this.imageUrl,
    this.hostForce,
    this.visitorForce,
    this.globalForce,
    this.matchCode,
  });

  factory Event.fromJson(json) {
    print(json);
    if (json["MatchCode"] != null) {
      return Event(
        date: DateTime.parse(json["DateMatch"]),
        name: json["CalendarEventName"] ?? json["LibelleMatch"],
        place: json["NomGymnase"],
        gymnasiumCode: json["GymnaseCode"],
        hostName: json["NomLocaux"],
        hostCode: json["EquipeLocauxCode"],
        visitorName: json["NomVisiteurs"],
        visitorCode: json["EquipeVisiteursCode"],
        type: EventType.Match,
        matchCode: json["MatchCode"],
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

  Event withForce(Force hostForce, Force visitorForce, Force globalForce) {
    return Event(
      date: date,
      name: name,
      place: place,
      gymnasiumCode: gymnasiumCode,
      type: type,
      hostName: hostName,
      hostCode: hostCode,
      visitorName: visitorName,
      visitorCode: visitorCode,
      endDate: endDate,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      clubCode: clubCode,
      description: description,
      imageUrl: imageUrl,
      hostForce: hostForce,
      visitorForce: visitorForce,
      globalForce: globalForce,
      matchCode: matchCode,
    );
  }

  static EventType _toEnumType(String? enumType) {
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
  List<Object?> get props => [name, date];
}

enum EventType { Match, Tournament, Meeting, Unknown }
