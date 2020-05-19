import 'package:flutter/cupertino.dart';

@immutable
class SetsDistribution {
  final int s30;
  final int s31;
  final int s32;
  final int s23;
  final int s13;
  final int s03;

  SetsDistribution({this.s30, this.s31, this.s32, this.s23, this.s13, this.s03});

  factory SetsDistribution.fromJson(Map<String, dynamic> json, String prefix) {
    return SetsDistribution(
        s30: json["${prefix}_3_0"],
        s31: json["${prefix}_3_1"],
        s32: json["${prefix}_3_2"],
        s23: json["${prefix}_1_3"],
        s13: json["${prefix}_1_3"],
        s03: json["${prefix}_0_3"]);
  }
}

@immutable
class TeamStat {
  final String codeTeam;
  final String teamName;

  final int matchs;
  final int matchsPlayed;
  final int matchsPlayedHome;
  final int matchsPlayedOutside;
  final int bestMatchsVictorySerie;
  final int worseMatchsDefeatSerie;

  final int victories;
  final int victoriesHome;
  final int victoriesOutside;
  final int victoriesForfeit;
  final SetsDistribution victoriesDistribution;

  final int defeats;
  final int defeatsHome;
  final int defeatsOutside;
  final SetsDistribution defeatsDistribution;

  final int forfeits;
  final int forfeitsHome;
  final int forfeitsOutside;

  final int setsWon;
  final int setsLost;

  final int pointsWon;
  final int pointsLost;

  TeamStat(this.codeTeam, this.teamName,
      {this.matchs,
        this.matchsPlayed,
        this.matchsPlayedHome,
        this.matchsPlayedOutside,
        this.bestMatchsVictorySerie,
        this.worseMatchsDefeatSerie,
        this.victories,
        this.victoriesHome,
        this.victoriesOutside,
        this.victoriesForfeit,
        this.victoriesDistribution,
        this.defeats,
        this.defeatsHome,
        this.defeatsOutside,
        this.defeatsDistribution,
        this.forfeits,
        this.forfeitsHome,
        this.forfeitsOutside,
        this.setsWon,
        this.setsLost,
        this.pointsWon,
        this.pointsLost});

  factory TeamStat.fromJson(Map<String, dynamic> json) {
    return TeamStat(
      json["CodeEquipe"],
      json["Equipe"],
      matchs: json["Matchs"],
      matchsPlayed: json["MatchsJoues"],
      matchsPlayedHome: json["MatchsDomicile"],
      matchsPlayedOutside: json["MatchsExterieur"],
      bestMatchsVictorySerie: json["MeilleureSerieVictoires"],
      worseMatchsDefeatSerie: json["PireSeriedefaites"],
      victories: json["Victoires"],
      victoriesHome: json["VictoiresDomicile"],
      victoriesOutside: json["VictoiresExterieur"],
      victoriesForfeit: json["VictoiresParForfait"],
      victoriesDistribution: SetsDistribution.fromJson(json, "Victoires"),
      defeats: json["Defaites"],
      defeatsHome: json["DefaitesDomicile"],
      defeatsOutside: json["DefaitesExterieur"],
      defeatsDistribution: SetsDistribution.fromJson(json, "Defaites"),
      forfeits: json["Forfait"],
      forfeitsHome: json["ForfaitDomicile"],
      forfeitsOutside: json["ForfaitExterieur"],
      setsWon: json["SetsGagnes"],
      setsLost: json["SetPerdus"],
      pointsWon: json["PointsGagnes"],
      pointsLost: json["PointsPerdus"],
    );
  }
}
