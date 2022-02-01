import 'package:flutter_test/flutter_test.dart';
import 'package:v34/models/force.dart';
import 'package:v34/models/match_result.dart';

void main() {
  test('Should compute simple 3 sets', () {
    MatchResult result = MatchResult.fromSets('T1', 'T2', [
      MatchSet(25, 20),
      MatchSet(25, 20),
      MatchSet(25, 20),
    ]);
    Forces forces = Forces();
    forces.add(result);
    expect(forces.getAttackPercentage('T1'), 1.25);
    expect(forces.getDefensePercentage('T1').isInfinite, true);
  });

  test('Should compute more than 3 sets', () {
    MatchResult result = MatchResult.fromSets('T1', 'T2', [
      MatchSet(25, 20),
      MatchSet(25, 20),
      MatchSet(20, 25),
      MatchSet(25, 20),
    ]);
    Forces forces = Forces();
    forces.add(result);
    expect(forces.getAttackPercentage('T1'), closeTo(1.11, 0.01));
    expect(forces.getDefensePercentage('T1'), 3);
  });

  test('Should compute sets with 0 point for a team', () {
    MatchResult result = MatchResult.fromSets('T1', 'T2', [
      MatchSet(25, 0),
      MatchSet(25, 0),
      MatchSet(25, 0),
    ]);
    Forces forces = Forces();
    forces.add(result);
    expect(forces.getAttackPercentage('T1').isInfinite, true);
    expect(forces.getDefensePercentage('T1').isInfinite, true);
    expect(forces.getAttackPercentage('T2'), 0);
    expect(forces.getDefensePercentage('T2'), 0);
  });

  test('Should homogenize sets with points highest then 25', () {
    MatchResult result = MatchResult.fromSets('T1', 'T2', [
      MatchSet(25, 0),
      MatchSet(26, 24), // ratio 26/25=1.04 (23,0769)
      MatchSet(25, 0),
    ]);
    Forces forces = Forces();
    forces.add(result);
    expect(forces.getAttackPercentage('T1'), closeTo(3.25, 0.01));
    expect(forces.getDefensePercentage('T1').isInfinite, true);
  });

  test('Should homogenize tie-break set', () {
    MatchResult result = MatchResult.fromSets('T1', 'T2', [
      MatchSet(25, 0),
      MatchSet(25, 0),
      MatchSet(0, 25),
      MatchSet(0, 25),
      MatchSet(15, 10), // ratio 15/25=0.6 (16.66667)
      // 15 / 13.333333
    ]);
    Forces forces = Forces();
    forces.add(result);
    expect(forces.getAttackPercentage('T1'), closeTo(1.12, 0.01));
    expect(forces.getDefensePercentage('T1'), closeTo(1.16, 0.01));
  });

  test('Should compute with 0 finished set', () {
    MatchResult result = MatchResult.fromSets('T1', 'T2', [
      MatchSet(20, 10),
    ]);
    Forces forces = Forces();
    forces.add(result);
    expect(forces.getAttackPercentage('T1'), 2.0);
    expect(forces.getDefensePercentage('T1').isInfinite, true);
    expect(forces.getAttackPercentage('T2'), 0.5);
    expect(forces.getDefensePercentage('T2'), 0);
  });

  test('Should compute forces taking into account other matches', () {
    Forces forces = Forces();
    forces.add(MatchResult.fromSets('T1', 'T2', [
      MatchSet(25, 20),
      MatchSet(25, 20),
      MatchSet(25, 20),
    ]));
    forces.add(MatchResult.fromSets('T3', 'T4', [
      MatchSet(25, 10),
      MatchSet(25, 10),
      MatchSet(25, 10),
    ]));
    // OA: 18.333333
    expect(forces.getAttackPercentage('T1'), closeTo(1.36, 0.01));
    expect(forces.getDefensePercentage('T1'), 1);
  });

  test('Should not compute forces when only other teams have played a match', () {
    Forces forces = Forces();
    forces.add(MatchResult.fromSets('T3', 'T4', [
      MatchSet(25, 10),
      MatchSet(25, 10),
      MatchSet(25, 10),
    ]));

    expect(forces.getAttackPercentage('T1').isNaN, true);
    expect(forces.getDefensePercentage('T1').isNaN, true);
  });

  test('Should not compute forces when no match has been played', () {
    Forces forces = Forces();
    expect(forces.getAttackPercentage('T1').isNaN, true);
    expect(forces.getDefensePercentage('T1').isNaN, true);
  });
}
