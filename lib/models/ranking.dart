class RankingTeamSynthesis {
  final String? name;
  final String? teamCode;
  final int? rank, totalPoints;
  final int? wonMatches, lostMatches;
  final int? wonSets, lostSets;
  final int? wonPoints, lostPoints;
  final int? nbSets30, nbSets31, nbSets32;
  final int? nbSets03, nbSets13, nbSets23;
  final int? nbSetsMI;
  final int? forfeitMatches;
  final int? setsDiff, pointsDiff;

  factory RankingTeamSynthesis.empty() => RankingTeamSynthesis(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
      );
  RankingTeamSynthesis(
    this.name,
    this.teamCode,
    this.rank,
    this.totalPoints,
    this.wonMatches,
    this.lostMatches,
    this.wonSets,
    this.lostSets,
    this.wonPoints,
    this.lostPoints,
    this.nbSets30,
    this.nbSets31,
    this.nbSets32,
    this.nbSets03,
    this.nbSets13,
    this.nbSets23,
    this.nbSetsMI,
    this.forfeitMatches,
    this.setsDiff,
    this.pointsDiff,
  );

  factory RankingTeamSynthesis.fromJson(Map<String, dynamic> json) {
    return RankingTeamSynthesis(
      json["Nom"],
      json["EquipeCode"],
      json["Rang"],
      json["Total"],
      json["Gagne"],
      json["Perdu"],
      json["SetP"],
      json["SetC"],
      json["PointsP"],
      json["PointsC"],
      json["NbSets_30"],
      json["NbSets_31"],
      json["NbSets_32"],
      json["NbSets_03"],
      json["NbSets_13"],
      json["NbSets_23"],
      json["NbSets_MI"],
      json["Forfait"],
      json["SefDiff"],
      json["PointDiff"],
    );
  }
}

class RankingSynthesis {
  final String? competitionCode;
  final int? promoted;
  final int? relegated;
  final String? label;
  final String? fullLabel;
  final String? division;
  final String? pool;
  final List<RankingTeamSynthesis>? ranks;

  RankingSynthesis(
      {this.competitionCode,
      this.label,
      this.fullLabel,
      this.promoted,
      this.relegated,
      this.division,
      this.pool,
      this.ranks});

  factory RankingSynthesis.fromJson(Map<String, dynamic> json) {
    return RankingSynthesis(
      competitionCode: json["CompetitionCode"],
      label: _getLabel(json["Libelle"]),
      fullLabel: json["Libelle"],
      promoted: json["Promus"],
      relegated: json["Relegue"],
      division: json["Division"],
      pool: json["Poule"],
      ranks:
          (json["classementDetail"] as List<dynamic>).map((detail) => RankingTeamSynthesis.fromJson(detail)).toList(),
    );
  }

  static String _getLabel(String label) {
    var extractedLabel = label.split(" ")[0];
    return extractedLabel;
  }
}
