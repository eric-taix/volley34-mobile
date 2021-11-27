import 'package:flutter/material.dart';

class Slot {
  final String? teamCode;
  final String? competitionCode;
  final String? slotId;
  final String? competitionType;
  final int? dayOfWeek;
  final TimeOfDay? startTime;
  final String? gymnasiumCode;
  final bool? principalSlot;
  final String? clubCode;

  Slot({
    this.teamCode,
    this.competitionCode,
    this.slotId,
    this.competitionType,
    this.dayOfWeek,
    this.startTime,
    this.gymnasiumCode,
    this.principalSlot,
    this.clubCode,
  });
  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      teamCode: json["EquipeCode"],
      competitionCode: json["CompetitionCode"],
      slotId: json["CreneauID"].toString(),
      competitionType: json["TypeCompetition"],
      dayOfWeek: json["CodeJourCreneaux"],
      startTime: TimeOfDay.fromDateTime(DateTime.parse('2012-02-27 ${json["Horaire"]}:00')),
      gymnasiumCode: json["CodeGymnase"],
      principalSlot: json["CreneauPrincipal"],
      clubCode: json["CodeClub"],
    );
  }
}
