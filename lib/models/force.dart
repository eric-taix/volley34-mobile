import 'match_result.dart';

class Force {
  int _homeAttack = 0;
  int _homeDefense = 0;
  int _outsideAttack = 0;
  int _outsideDefense = 0;
  int _countHome = 0;
  int _countOutside = 0;

  Force();

  double get homeAttackPerSet => _countHome != 0 ? _homeAttack / _countHome : 0;
  double get homeDefensePerSet => _countHome != 0 ? _homeDefense / _countHome : 0;
  double get outsideAttackPerSet => _countOutside != 0 ? _outsideAttack / _countOutside : 0;
  double get outsideDefensePerSet => _countOutside != 0 ? _outsideDefense / _countOutside : 0;

  int get homeAttack => _homeAttack;
  int get countHome => _countHome;
  int get outsideAttack => _outsideAttack;
  int get countOutside => _countOutside;

  int get totalCount => _countHome + _countOutside;
  double get totalAttackPerSet => totalCount != 0 ? ((_homeAttack + _outsideAttack) / totalCount).toDouble() : 0;
  double get totalDefensePerSet => totalCount != 0 ? ((_homeDefense + _outsideDefense) / totalCount).toDouble() : 0;

  void withHomeResult(int attack, int defense, int setCount) {
    _homeAttack = _homeAttack + attack;
    _homeDefense = _homeDefense + defense;
    _countHome = _countHome + setCount;
  }

  void withVisitorResult(int attack, int defense, int setCount) {
    _outsideAttack = _outsideAttack + attack;
    _outsideDefense = _outsideDefense + defense;
    _countOutside = _countOutside + setCount;
  }

  @override
  String toString() {
    return 'Force{homeAttack: $_homeAttack, homeDefense: $_homeDefense, outsideAttack: $_outsideAttack, outsideDefense: $_outsideDefense, countHome: $_countHome, countOutside: $_countOutside}';
  }
}

class ForceBuilder {
  late final String? teamCode;

  Force _teamForce = Force();
  late Force _othersForce;

  ForceBuilder({required this.teamCode, Force? othersForce}) {
    this._othersForce = othersForce ?? Force();
  }

  void add(MatchResult matchResult) {
    if (matchResult.hostTeamCode == teamCode) {
      teamForce.withHomeResult(matchResult.totalPointsHost ?? 0, matchResult.totalPointsVisitor ?? 0,
          (matchResult.totalSetsHost ?? 0) + (matchResult.totalSetsVisitor ?? 0));
    }
    _othersForce.withHomeResult(matchResult.totalPointsHost ?? 0, matchResult.totalPointsVisitor ?? 0,
        (matchResult.totalSetsHost ?? 0) + (matchResult.totalSetsVisitor ?? 0));

    if (matchResult.visitorTeamCode == teamCode) {
      _teamForce.withVisitorResult(matchResult.totalPointsVisitor ?? 0, matchResult.totalPointsHost ?? 0,
          (matchResult.totalSetsHost ?? 0) + (matchResult.totalSetsVisitor ?? 0));
    }
    _othersForce.withVisitorResult(matchResult.totalPointsVisitor ?? 0, matchResult.totalPointsHost ?? 0,
        (matchResult.totalSetsHost ?? 0) + (matchResult.totalSetsVisitor ?? 0));
  }

  Force get teamForce => _teamForce;
  Force get othersForce => _othersForce;

  @override
  String toString() {
    return "\nother: $othersForce\n";
  }
}
