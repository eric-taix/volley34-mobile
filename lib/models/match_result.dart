class MatchSet {
  final int? hostPoint;
  final int? visitorpoint;

  MatchSet(this.hostPoint, this.visitorpoint);
}

const VALID_RESULT_TYPES = [
  MatchResultType.VALID,
  MatchResultType.HOME_FORFEIT,
  MatchResultType.VISITOR_FORFEIT,
  MatchResultType.GENERAL_FORFEIT,
  MatchResultType.MATCH_UNFINISHED,
  MatchResultType.NO_MATCH_SHEET,
];

class MatchResult {
  final String? matchCode;
  final int? season;
  final String? matchTitle;
  final List<MatchSet>? sets;
  final int? totalSetsHost;
  final int? totalSetsVisitor;
  final int? totalPointsHost;
  final int? totalPointsVisitor;
  final String? hostName;
  final String? visitorName;
  final String? hostTeamCode;
  final String? visitorTeamCode;
  final DateTime? matchDate;
  final String? competitionCode;
  final MatchResultType resultType;

  MatchResult({
    this.matchCode,
    this.season,
    this.matchTitle,
    this.sets,
    this.totalSetsHost,
    this.totalSetsVisitor,
    this.totalPointsHost,
    this.totalPointsVisitor,
    this.hostName,
    this.visitorName,
    this.hostTeamCode,
    this.visitorTeamCode,
    this.matchDate,
    this.competitionCode,
    required this.resultType,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    var match = json["matchs"];

    return MatchResult(
        resultType: _toEnumType(json["TypeResultat"]),
        matchCode: json["MatchCode"],
        season: json["Saison"],
        matchTitle: json["ResultatLibelleMatch"],
        sets: [
          MatchSet(json["Set1Locaux"], json["Set1Visiteurs"]),
          MatchSet(json["Set2Locaux"], json["Set2Visiteurs"]),
          MatchSet(json["Set3Locaux"], json["Set3Visiteurs"]),
          MatchSet(json["Set4Locaux"], json["Set4Visiteurs"]),
          MatchSet(json["Set5Locaux"], json["Set5Visiteurs"]),
        ],
        totalSetsHost: json["TotalSetLocaux"],
        totalSetsVisitor: json["TotalSetVisiteurs"],
        totalPointsHost: json["TotalPointLocaux"],
        totalPointsVisitor: json["TotalPointVisiteurs"],
        hostName: match["NomLocaux"],
        visitorName: match["NomVisiteurs"],
        hostTeamCode: match["EquipeLocauxCode"],
        visitorTeamCode: match["EquipeVisiteursCode"],
        matchDate: DateTime.parse(match["DateMatch"].toString()),
        competitionCode: match["CompetitionCode"]);
  }

  static MatchResultType _toEnumType(String? resultType) {
    switch (resultType) {
      case "V":
        return MatchResultType.VALID;
      case "FL":
        return MatchResultType.HOME_FORFEIT;
      case "FV":
        return MatchResultType.VISITOR_FORFEIT;
      case "FG":
        return MatchResultType.GENERAL_FORFEIT;
      case "NJ":
        return MatchResultType.NOT_PLAYED;
      case "MI":
        return MatchResultType.MATCH_UNFINISHED;
      case "ND":
        return MatchResultType.NON_DETAILED;
      case "NF":
        return MatchResultType.NO_MATCH_SHEET;
    }
    return MatchResultType.UNKNOWN;
  }
}

enum MatchResultType {
  UNKNOWN,
  VALID,
  HOME_FORFEIT,
  VISITOR_FORFEIT,
  GENERAL_FORFEIT,
  NOT_PLAYED,
  MATCH_UNFINISHED,
  NON_DETAILED,
  NO_MATCH_SHEET
}
