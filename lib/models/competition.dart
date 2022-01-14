enum PlayType { t_6x6, t_4x4, t_unknown, t_all }

enum PlaySex { male, female, mix, unknown, all }

PlaySex playSexFromJson(String value) {
  if (value == "M") return PlaySex.male;
  if (value == "F") return PlaySex.female;
  if (value == "X") return PlaySex.mix;
  return PlaySex.mix;
}

PlayType playTypeFromJson(String value) {
  if (value == "4x4") return PlayType.t_4x4;
  if (value == "6x6") return PlayType.t_6x6;
  return PlayType.t_unknown;
}

class CompetitionPlay {
  final PlaySex sex;
  final PlayType type;

  static final CompetitionPlay all = CompetitionPlay(PlaySex.all, PlayType.t_all);

  CompetitionPlay(this.sex, this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetitionPlay && runtimeType == other.runtimeType && sex == other.sex && type == other.type;

  @override
  int get hashCode => sex.hashCode ^ type.hashCode;
}

class Competition {
  final String code;
  final int season;
  final PlaySex sex;
  final PlayType type;
  final String label;
  final DateTime start;
  final DateTime end;
  final String groupId;

  String get competitionLabel {
    int index = label.indexOf("-");
    if (index != -1) {
      return label.substring(0, index);
    } else {
      return label;
    }
  }

  Competition({
    required this.code,
    required this.season,
    required this.sex,
    required this.type,
    required this.label,
    required this.start,
    required this.end,
    required this.groupId,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      code: json["CompetitionCode"],
      season: json["Saison"],
      sex: playSexFromJson(json["RegroupementSexe"]),
      type: playTypeFromJson(json["TypedeJeu"]),
      label: json["LibelleCompetition"],
      start: DateTime.parse(json["DateDebut"]),
      end: DateTime.parse(json["DateFin"]),
      groupId: json["CompetitionGroupID"],
    );
  }
}

class TeamCompetition {
  final String code;
  final int season;
  final PlaySex sex;
  final PlayType type;
  final String label;
  final DateTime start;
  final DateTime end;
  final String division;
  final String pool;

  TeamCompetition({
    required this.code,
    required this.season,
    required this.sex,
    required this.type,
    required this.label,
    required this.start,
    required this.end,
    required this.division,
    required this.pool,
  });

  factory TeamCompetition.fromJson(Map<String, dynamic> json) {
    return TeamCompetition(
      code: json["CompetitionCode"],
      season: json["Saison"],
      sex: playSexFromJson(json["RegroupementSexe"]),
      type: playTypeFromJson(json["TypedeJeu"]),
      label: json["LibelleCompetition"],
      start: DateTime.parse(json["DateDebut"]),
      end: DateTime.parse(json["DateFin"]),
      division: json["division"],
      pool: json["poule"],
    );
  }
}
