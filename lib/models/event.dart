import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:v34/models/force.dart';

@immutable
class Event extends Equatable {
  // Common
  late final DateTime? _date;
  DateTime? get date => _postponedDate ?? _date;
  DateTime? get initialDate => _date;

  final String? place;
  final EventType? type;
  final String? name;

  // Match
  final String? hostName;
  final String? hostCode;
  final String? visitorName;
  final String? visitorCode;

  late final String? _gymnasiumCode;
  String? get gymnasiumCode => _postponedGymnasiumCode ?? _gymnasiumCode;
  String? get initialGymnasiumCode => _gymnasiumCode;

  final Force? hostForce;
  final Force? visitorForce;
  final Force? globalForce;
  final String? matchCode;
  late final DateTime? _postponedDate;
  late final String? _postponedGymnasiumCode;
  final bool hasResult;

  DateTime? get postponedDate => _postponedDate != _date ? _postponedDate : null;
  String? get postponedGymnasiumCode => _postponedGymnasiumCode != _gymnasiumCode ? _postponedGymnasiumCode : null;

  // Tournament & Meeting
  final DateTime? endDate;
  final String? contactName, contactPhone, contactEmail;
  final String? description;
  final String? clubCode;

  final String? imageUrl;

  Event({
    DateTime? date,
    this.name,
    this.place,
    String? gymnasiumCode,
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
    this.hasResult = false,
    DateTime? postponedDate,
    String? postponedGymnasiumCode,
  }) {
    _date = date;
    _gymnasiumCode = gymnasiumCode;
    _postponedDate = postponedDate;
    _postponedGymnasiumCode = postponedGymnasiumCode;
  }

  factory Event.fromJson(json) {
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
        postponedDate: json["DateMatchRevisee"] != null ? DateTime.parse(json["DateMatchRevisee"]) : null,
        postponedGymnasiumCode: json["GymnaseCodeRevise"],
        hasResult: false,
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
      date: _date,
      name: name,
      place: place,
      gymnasiumCode: _gymnasiumCode,
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
      postponedDate: _postponedDate,
      postponedGymnasiumCode: _postponedGymnasiumCode,
      hasResult: hasResult,
    );
  }

  Event withResult() {
    return Event(
      date: _date,
      name: name,
      place: place,
      gymnasiumCode: _gymnasiumCode,
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
      postponedDate: _postponedDate,
      postponedGymnasiumCode: _postponedGymnasiumCode,
      hasResult: true,
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
