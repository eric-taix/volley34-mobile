import 'package:flutter/cupertino.dart';

@immutable
class SetsDistribution {
  final int? s30;
  final int? s31;
  final int? s32;
  final int? s23;
  final int? s13;
  final int? s03;

  SetsDistribution({this.s30 = 0, this.s31 = 0, this.s32 = 0, this.s23 = 0, this.s13 = 0, this.s03 = 0});

  factory SetsDistribution.fromJson(Map<String, dynamic> json) {
    return SetsDistribution(
        s30: json["Victoires_3_0"],
        s31: json["Victoires_3_1"] + json["Victoires_2_0"],
        s32: json["Victoires_3_2"] +
            json["Victoires_0_0"] +
            json["Victoires_1_0"] +
            json["Victoires_1_1"] +
            json["Victoires_2_1"] +
            json["Victoires_2_2"],
        s23: json["Defaites_2_3"] +
            json["Defaites_0_0"] +
            json["Defaites_0_1"] +
            json["Defaites_1_1"] +
            json["Defaites_1_2"] +
            json["Defaites_2_2"],
        s13: json["Defaites_1_3"] + json["Defaites_0_2"],
        s03: json["Defaites_0_3"]);
  }

  operator +(SetsDistribution other) {
    return SetsDistribution(
      s30: s30! + other.s30!,
      s31: s31! + other.s31!,
      s32: s32! + other.s32!,
      s23: s23! + other.s23!,
      s13: s13! + other.s13!,
      s03: s03! + other.s03!,
    );
  }

  int get maxValue {
    int max = 0;
    if (s30! > max) max = s30!;
    if (s31! > max) max = s31!;
    if (s32! > max) max = s32!;
    if (s23! > max) max = s23!;
    if (s13! > max) max = s13!;
    if (s03! > max) max = s03!;
    return max;
  }
}

@immutable
class TeamStat {
  final String? codeTeam;
  final String? teamName;

  final int? matchs;
  final int? matchsPlayed;
  final int? matchsPlayedHome;
  final int? matchsPlayedOutside;
  final int? bestMatchsVictorySerie;
  final int? worseMatchsDefeatSerie;

  final int? victories;
  final int? victoriesHome;
  final int? victoriesOutside;
  final int? victoriesForfeit;
  final SetsDistribution? setsDistribution;

  final int? defeats;
  final int? defeatsHome;
  final int? defeatsOutside;

  final int? forfeits;
  final int? forfeitsHome;
  final int? forfeitsOutside;

  final int? setsWon;
  final int? setsLost;

  final int? pointsWon;
  final int? pointsLost;

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
      this.setsDistribution,
      this.defeats,
      this.defeatsHome,
      this.defeatsOutside,
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
      setsDistribution: SetsDistribution.fromJson(json),
      defeats: json["Defaites"],
      defeatsHome: json["DefaitesDomicile"],
      defeatsOutside: json["DefaitesExterieur"],
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
