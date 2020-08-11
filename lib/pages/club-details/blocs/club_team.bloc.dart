//---- STATE
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/repositories/repository.dart';

class ValuePerMax {
  final int value;
  final int maximum;

  ValuePerMax({this.value = 0, this.maximum = 0});
}

class ValuePerMaxMin {
  final int value;
  final int maximum;
  final int minimum;

  ValuePerMaxMin({this.value = 0, this.maximum = 0, this.minimum = 0});
}

@immutable
abstract class TeamState {}

class TeamStateUninitialized extends TeamState {}

class TeamSlidingStatsLoading extends TeamState {}

class TeamSlidingStatsLoaded extends TeamState {
  final List<double> pointsDiffEvolution;
  final ValuePerMax pointsPerMax;
  final ValuePerMaxMin pointsPerMaxWithFactor;

  TeamSlidingStatsLoaded(
      {this.pointsDiffEvolution,
      this.pointsPerMax,
      this.pointsPerMaxWithFactor});
}

class TeamResultsLoaded extends TeamState {
  final List<MatchResult> results;

  TeamResultsLoaded({@required this.results});
}

//---- EVENT
@immutable
abstract class TeamEvent {}

class TeamLoadSlidingResult extends TeamEvent {
  final String code;
  final int last;

  TeamLoadSlidingResult({this.code, this.last});
}

class TeamLoadAverageSlidingResult extends TeamEvent {
  final String code;
  final int last;
  final int count;

  TeamLoadAverageSlidingResult({this.code, this.last, this.count});
}

class TeamLoadResults extends TeamEvent {
  final String code;
  final int last;

  TeamLoadResults({@required this.code, @required this.last});
}

//---- BLOC
class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final Repository repository;

  TeamBloc({@required this.repository}) : super(TeamStateUninitialized());

  @override
  Stream<TeamState> mapEventToState(TeamEvent event) async* {
    if (event is TeamLoadSlidingResult) {
      yield TeamSlidingStatsLoading();
      var results =
          await repository.loadTeamLastMatchesResult(event.code, event.last);
      var pointDiffs = computePointsDiffs(results, event.code);
      yield TeamSlidingStatsLoaded(pointsDiffEvolution: pointDiffs);
    }

    if (event is TeamLoadAverageSlidingResult) {
      yield TeamSlidingStatsLoading();
      var results =
          await repository.loadTeamLastMatchesResult(event.code, event.last);

      var pointDiffs = computePointsDiffs(results, event.code);
      var averagePointDiffs = List.generate(event.count, (index) {
        double sum = 0;
        for (int i = index * event.count; i < (index + 1) * event.count; i++) {
          if (i < results.length) sum += pointDiffs[i];
        }
        return sum / event.count;
      }).toList();

      var pointsPerMax = _computePointsPerMax(event.code, results);
      var pointPerMaxWithFactor = _computePointsDiffWithFactor(
          event.code, results, [1.0, 1.2, 1.4, 8.0, 32.0]);
      yield TeamSlidingStatsLoaded(
        pointsDiffEvolution: averagePointDiffs..insert(0, 0),
        pointsPerMax: pointsPerMax,
        pointsPerMaxWithFactor: pointPerMaxWithFactor,
      );
    }

    if (event is TeamLoadResults) {
      yield TeamSlidingStatsLoading();
      var results =
          await repository.loadTeamLastMatchesResult(event.code, event.last);
      yield TeamResultsLoaded(results: results);
    }
  }

  ValuePerMaxMin _computePointsDiffWithFactor(
      String teamCode, List<MatchResult> results, List<double> factors) {
    assert(factors != null);
    assert(factors.length == 5);

    var pointPerMaxWithFactor = results.fold(ValuePerMaxMin(), (acc, result) {
      var set = result.sets.asMap().entries.fold(ValuePerMaxMin(), (acc, set) {
        if (set.value.hostPoint != null) {
          var diff = 0;
          if (set.key > 0) {
            var previousSet = result.sets[set.key - 1];
            var previousDiff = result.hostTeamCode == teamCode
                ? previousSet.hostPoint - (previousSet.visitorpoint ?? 0)
                : (previousSet.visitorpoint ?? 0) - previousSet.hostPoint;
            var currentDiff = result.hostTeamCode == teamCode
                ? set.value.hostPoint - (set.value.visitorpoint ?? 0)
                : (set.value.visitorpoint ?? 0) - set.value.hostPoint;
            diff = currentDiff - previousDiff;
          }
          return ValuePerMaxMin(
            value: acc.value + (diff * factors[set.key]).toInt(),
            minimum: ((set.key == 5 ? -15 : -25) * factors[set.key]).toInt(),
            maximum: ((set.key == 5 ? 15 : 25) * factors[set.key]).toInt(),
          );
        }
        return acc;
      });
      return ValuePerMaxMin(
          value: acc.value + set.value,
          maximum: acc.maximum + set.maximum.toInt(),
          minimum: acc.minimum - set.minimum.toInt());
    });
    return pointPerMaxWithFactor;
  }

  ValuePerMax _computePointsPerMax(String teamCode, List<MatchResult> results) {
    var pointsPerMax = results.fold(ValuePerMax(), (acc, result) {
      var set = result.sets.fold(ValuePerMax(), (acc, set) {
        if (set.hostPoint != null) {
          return ValuePerMax(
            value: acc.value +
                (result.hostTeamCode == teamCode
                    ? set.hostPoint
                    : (set.visitorpoint ?? 0)),
            maximum: acc.maximum +
                (set.hostPoint > (set.visitorpoint ?? 0)
                    ? set.hostPoint
                    : (set.visitorpoint ?? 0)),
          );
        }
        return acc;
      });
      return ValuePerMax(
          value: acc.value + set.value, maximum: acc.maximum + set.maximum);
    });
    return pointsPerMax;
  }

  static List<double> computePointsDiffs(
      List<MatchResult> matchResults, String code) {
    var setsDiff = matchResults.map((result) {
      bool isHost = result.hostTeamCode == code;
      return (result.totalSetsHost - result.totalSetsVisitor) *
          (isHost ? 1 : -1);
    }).toList();
/*    for (int i = 0; i < setsDiff.length - 1; i++) {
      setsDiff[i + 1] += setsDiff[i];
    }*/
    return setsDiff.map((d) => d.toDouble()).toList();
  }

  static List<double> computeCumulativePointsDiffs(List<double> pointsDiff) {
    List<double> cumulativePointsDiff = List(pointsDiff.length);
    if (pointsDiff.length > 0) cumulativePointsDiff[0] = pointsDiff[0];
    for (int i = 0; i < cumulativePointsDiff.length - 1; i++) {
      cumulativePointsDiff[i + 1] = pointsDiff[i + 1] + cumulativePointsDiff[i];
    }
    return cumulativePointsDiff;
  }
}
