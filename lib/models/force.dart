import 'dart:math';

import 'match_result.dart';

class _TeamForce {
  double _attack = 0;
  double _defense = 0;
  double _count = 0;

  static final empty = _TeamForce();

  _TeamForce({double attack = 0, double defense = 0, double count = 0}) {
    _attack = attack;
    _defense = defense;
    _count = count;
  }

  double get attackPerSet => _count != 0 ? _attack / _count : 0;
  double get defensePerSet => _count != 0 ? 25 - (_defense / _count) : 0;
  double get count => _count;

  operator +(_TeamForce force) =>
      _TeamForce(attack: _attack + force._attack, defense: _defense + force._defense, count: _count + force.count);

  void withResult(double attack, double defense) {
    _attack += attack;
    _defense += defense;
    _count += 3;
  }

  @override
  String toString() {
    return 'Force { attack=$_attack, defense=$_defense count=$_count }';
  }
}

class Forces {
  Map<String, _TeamForce> _forceByTeam = Map();

  Forces();

  void add(MatchResult matchResult) {
    if ((matchResult.totalPointsHost ?? 0) > 0 || (matchResult.totalPointsVisitor ?? 0) > 0) {
      var totalPoints = matchResult.sets!.where((set) => set.hostPoint != null && set.visitorpoint != null).map((set) {
        double ratio =
            (set.hostPoint ?? 0) > (set.visitorpoint ?? 0) ? (set.hostPoint ?? 0) / 25 : (set.visitorpoint ?? 0) / 25;
        return _RegularSet(
            (set.hostPoint ?? 0) / (ratio != 0 ? ratio : 1), (set.visitorpoint ?? 0) / (ratio != 0 ? ratio : 1));
      }).reduce((acc, set) => acc + set);

      double totalSets = ((matchResult.totalSetsHost ?? 0) + (matchResult.totalSetsVisitor ?? 0)).toDouble();
      double averageHostPoint = (totalPoints.hostPoint / max(totalSets, 1)) * 3;
      double averageVisitorPoint = (totalPoints.visitorPoint / max(totalSets, 1)) * 3;

      _TeamForce hostForce = _forceByTeam.putIfAbsent(matchResult.hostTeamCode!, () => _TeamForce());
      _TeamForce visitorForce = _forceByTeam.putIfAbsent(matchResult.visitorTeamCode!, () => _TeamForce());

      hostForce.withResult(averageHostPoint, averageVisitorPoint);
      visitorForce.withResult(averageVisitorPoint, averageHostPoint);
    }
  }

  _TeamForce getTeamForce(String teamCode) => _forceByTeam.putIfAbsent(teamCode, () => _TeamForce());

  _TeamForce getOpponentsForce(String teamCode) =>
      _forceByTeam.entries.where((entry) => entry.key != teamCode).fold(_TeamForce(), (otherForce, teamForce) {
        return otherForce + teamForce.value;
      });

  double getAttackPercentage(String teamCode) {
    var teamForce = getTeamForce(teamCode);
    if (teamForce.count == 0) {
      return double.nan;
    }
    var teamAttack = teamForce.attackPerSet;
    var opponentAttack = getOpponentsForce(teamCode).attackPerSet;
    return teamAttack == 0 && opponentAttack == 0 ? 1 : teamAttack / opponentAttack;
  }

  double getDefensePercentage(String teamCode) {
    var teamForce = getTeamForce(teamCode);
    if (teamForce.count == 0) {
      return double.nan;
    }
    var teamDefense = getTeamForce(teamCode).defensePerSet;
    var opponentDefense = getOpponentsForce(teamCode).defensePerSet;
    return teamDefense == 0 && opponentDefense == 0 ? 1 : teamDefense / opponentDefense;
  }

  @override
  String toString() {
    return 'Forces{ $_forceByTeam}';
  }
}

class _RegularSet {
  final double hostPoint;
  final double visitorPoint;
  _RegularSet(this.hostPoint, this.visitorPoint);

  operator +(_RegularSet otherSet) {
    return _RegularSet(hostPoint + otherSet.hostPoint, visitorPoint + otherSet.visitorPoint);
  }
}
