import 'match_result.dart';

class Force {
  final double homeAttack;
  final double homeDefense;
  final double outsideAttack;
  final double outsideDefense;
  final int countHome;
  final int countOutside;

  Force(
      {required this.homeAttack,
      required this.homeDefense,
      required this.outsideAttack,
      required this.outsideDefense,
      this.countHome = 0,
      this.countOutside = 0});

  factory Force.zero() => Force(homeAttack: 0, homeDefense: 0, outsideAttack: 0, outsideDefense: 0);

  double get homeAttackRatio => countHome != 0 ? homeAttack / countHome : 0;
  double get homeDefenseRatio => countHome != 0 ? homeDefense / countHome : 0;
  double get outsideAttackRatio => countOutside != 0 ? outsideAttack / countOutside : 0;
  double get outsideDefenseRatio => countOutside != 0 ? outsideDefense / countOutside : 0;

  Force withHomeResult(double attack, double defense) {
    return Force(
      homeAttack: homeAttack + attack,
      homeDefense: homeDefense + defense,
      outsideAttack: outsideAttack,
      outsideDefense: outsideDefense,
      countHome: countHome + 1,
      countOutside: countOutside,
    );
  }

  Force withVisitorResult(double attack, double defense) {
    return Force(
      homeAttack: homeAttack,
      homeDefense: homeDefense,
      outsideAttack: outsideAttack + attack,
      outsideDefense: outsideDefense + defense,
      countHome: countHome,
      countOutside: countOutside + 1,
    );
  }

  @override
  String toString() {
    return 'Force{homeAttack: $homeAttack, homeDefense: $homeDefense, outsideAttack: $outsideAttack, outsideDefense: $outsideDefense, countHome: $countHome, countOutside: $countOutside}';
  }
}

class ForceBuilder {
  late final String? teamCode;

  Force _teamForce = Force.zero();
  Force _othersForce = Force.zero();

  ForceBuilder({required this.teamCode});

  void add(MatchResult matchResult) {
    if (matchResult.hostTeamCode == teamCode) {
      _teamForce = _teamForce.withHomeResult(matchResult.regularTotalPointsHost, matchResult.regularTotalPointsVisitor);
    } else {
      _othersForce =
          _othersForce.withHomeResult(matchResult.regularTotalPointsHost, matchResult.regularTotalPointsVisitor);
    }
    if (matchResult.visitorTeamCode == teamCode) {
      _teamForce =
          _teamForce.withVisitorResult(matchResult.regularTotalPointsVisitor, matchResult.regularTotalPointsHost);
    } else {
      _othersForce =
          _othersForce.withVisitorResult(matchResult.regularTotalPointsVisitor, matchResult.regularTotalPointsHost);
    }
  }

  Force get teamForce => _teamForce;
  Force get othersForce => _othersForce;
}
