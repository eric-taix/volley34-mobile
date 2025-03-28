import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/models/force.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';
//---- MODEL

class TeamCompetitionSynthesis extends Equatable {
  final RankingSynthesis? rankingSynthesis;
  final List<double>? pointsDiffEvolution;
  final int? totalMatches;
  final int? wonMatches;

  TeamCompetitionSynthesis({
    this.rankingSynthesis,
    this.pointsDiffEvolution,
    this.totalMatches,
    this.wonMatches,
  });

  @override
  List<Object?> get props => [rankingSynthesis, pointsDiffEvolution];
}

class CompetitionFullPath {
  final String competitionCode;
  final String division;
  final String pool;

  CompetitionFullPath(this.competitionCode, this.division, this.pool);

  @override
  String toString() {
    return 'CompetitionFullPath{competitionCode: $competitionCode, division: $division, pool: $pool}';
  }
}

//---- STATE

class ValuePerMax {
  final int? value;
  final int? maximum;

  ValuePerMax({this.value = 0, this.maximum = 0});
}

class ValuePerMaxMin {
  final int? value;
  final int? maximum;
  final int? minimum;

  ValuePerMaxMin({this.value = 0, this.maximum = 0, this.minimum = 0});
}

@immutable
abstract class TeamState extends Equatable {}

class TeamStateUninitialized extends TeamState {
  @override
  List<Object?> get props => [];
}

class TeamSlidingStatsLoading extends TeamState {
  @override
  List<Object?> get props => [];
}

class TeamSlidingStatsLoaded extends TeamState {
  final Map<String, TeamCompetitionSynthesis> competitions;
  final String? firstShownCompetition;

  TeamSlidingStatsLoaded({required this.competitions, this.firstShownCompetition});

  @override
  List<Object?> get props => [competitions];
}

class TeamResultsLoaded extends TeamState {
  final List<MatchResult> results;

  TeamResultsLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class TeamDivisionPoolResultsLoaded extends TeamState {
  final List<MatchResult> teamResults;
  final List<MatchResult> allResults;
  final Map<String, Forces> forceByCompetitionCode;

  TeamDivisionPoolResultsLoaded({
    required this.teamResults,
    required this.allResults,
    required this.forceByCompetitionCode,
  });

  @override
  List<Object?> get props => [teamResults, allResults];
}

//---- EVENT
@immutable
abstract class TeamEvent {}

class TeamLoadSlidingResult extends TeamEvent {
  final String code;
  final int? last;

  TeamLoadSlidingResult({required this.code, this.last});
}

class TeamLoadAverageSlidingResult extends TeamEvent {
  final Team team;
  final int? last;
  final int? count;

  TeamLoadAverageSlidingResult({required this.team, this.last, this.count});
}

class TeamLoadResults extends TeamEvent {
  final String? code;
  final int last;

  TeamLoadResults({required this.code, required this.last});
}

class TeamLoadDivisionPoolResults extends TeamEvent {
  final List<CompetitionFullPath> competitionsFullPath;
  final String teamCode;

  TeamLoadDivisionPoolResults({required this.teamCode, required this.competitionsFullPath});
}

//---- BLOC
class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final Repository repository;

  TeamBloc({required this.repository}) : super(TeamStateUninitialized()) {
    on<TeamLoadSlidingResult>((event, emit) async {
      emit(TeamSlidingStatsLoading());
      var results = await repository.loadTeamLastMatchesResult(event.code, event.last!);
      var teamCompetitionSynthesisByCode = results
          .where((result) => result.competitionCode != null)
          .groupListsBy((result) => result.competitionCode!)
          .map(
            (key, value) => MapEntry(
              key,
              TeamCompetitionSynthesis(
                pointsDiffEvolution: computePointsDiffs(results, event.code),
              ),
            ),
          );

      var competitions = await repository.loadAllCompetitions();
      var teamCompetitionSynthesisCodes = teamCompetitionSynthesisByCode.keys;
      var teamCompetitions =
          competitions.where((competition) => teamCompetitionSynthesisCodes.contains(competition.code)).toList();

      emit(TeamSlidingStatsLoaded(
          competitions: teamCompetitionSynthesisByCode,
          firstShownCompetition: teamCompetitions.firstShownCompetition()?.code));
    });

    on<TeamLoadAverageSlidingResult>((event, emit) async {
      emit(TeamSlidingStatsLoading());
      List<RankingSynthesis> rankings = (await repository.loadTeamRankingSynthesis(event.team.code)).map((ranking) {
        return ranking..ranks?.sort(sortByRank);
      }).toList();

      List<TeamCompetition> competitions = await repository.loadTeamCompetitions(event.team);
      var teamCompetitionSynthesis = await Future.wait(competitions.map((competition) async {
        var matchResults = await repository.loadResults(competition.code, competition.division, competition.pool);
        var pointDiffs = computePointsDiffs(matchResults, event.team.code);
        double sum = 0;
        var sumPointDiffs = List.generate(pointDiffs.length, (index) {
          sum += pointDiffs[index];
          return sum;
        }).toList();

        int totalMatches = 0;
        int wonMatches = 0;
        matchResults.where(_isTeamPlayed(event.team.code)).forEach((matchResult) {
          totalMatches++;
          if (_isTeamWon(event.team.code, matchResult)) {
            wonMatches++;
          }
        });

        return MapEntry(
            competition.code,
            TeamCompetitionSynthesis(
              rankingSynthesis: rankings.firstWhere((ranking) => ranking.competitionCode == competition.code),
              pointsDiffEvolution: sumPointDiffs,
              totalMatches: totalMatches,
              wonMatches: wonMatches,
            ));
      }));
      var unsorted = Map<String, TeamCompetitionSynthesis>.fromIterable(teamCompetitionSynthesis,
          key: (entry) => entry.key, value: (entry) => entry.value);

      emit(
        TeamSlidingStatsLoaded(
            competitions: unsorted, firstShownCompetition: competitions.firstShownCompetition()?.code),
      );
    });

    on<TeamLoadResults>((event, emit) async {
      emit(TeamSlidingStatsLoading());
      var results = await repository.loadTeamLastMatchesResult(event.code, event.last);
      emit(TeamResultsLoaded(results: results));
    });

    on<TeamLoadDivisionPoolResults>((event, emit) async {
      emit(TeamSlidingStatsLoading());
      var matchResults = (await Future.wait(event.competitionsFullPath.map((competitionFullPath) async {
        var results = await repository.loadResults(
            competitionFullPath.competitionCode, competitionFullPath.division, competitionFullPath.pool);
        return results;
      })))
          .expand((results) => results)
          .toList()
        ..sort((m1, m2) => m1.matchDate!.compareTo(m2.matchDate!));

      Map<String, Forces> forceByCompetition =
          matchResults.groupListsBy((matchResult) => matchResult.competitionCode).map((competitionCode, matchResults) {
        Forces forceBuilder =
            matchResults.fold<Forces>(Forces(), (forceBuilder, matchResult) => forceBuilder..add(matchResult));
        return MapEntry(competitionCode!, forceBuilder);
      });

      emit(TeamDivisionPoolResultsLoaded(
        teamResults: matchResults
            .where((matchResult) =>
                matchResult.hostTeamCode == event.teamCode || matchResult.visitorTeamCode == event.teamCode)
            .toList(),
        allResults: matchResults.toList(),
        forceByCompetitionCode: forceByCompetition,
      ));
    });
  }

  int sortByRank(RankingTeamSynthesis team1, RankingTeamSynthesis team2) {
    return team1.rank!.compareTo(team2.rank!) * -1;
  }

  static bool Function(MatchResult) _isTeamPlayed(String? teamCode) =>
      (matchResult) => matchResult.hostTeamCode == teamCode || matchResult.visitorTeamCode == teamCode;
  static bool _isTeamWon(String? teamCode, MatchResult matchResult) {
    bool hosted = matchResult.hostTeamCode == teamCode;
    if ((hosted && (matchResult.totalSetsHost ?? 0) > (matchResult.totalSetsVisitor ?? 0)) ||
        (!hosted && (matchResult.totalSetsHost ?? 0) < (matchResult.totalSetsVisitor ?? 0))) {
      return true;
    } else {
      return false;
    }
  }

  static List<double> computePointsDiffs(List<MatchResult> matchResults, String? teamCode) {
    var setsDiff = matchResults
        .where((matchResult) => matchResult.hostTeamCode == teamCode || matchResult.visitorTeamCode == teamCode)
        .map((matchResult) {
      return ((matchResult.totalSetsHost! - matchResult.totalSetsVisitor!) *
              (matchResult.hostTeamCode == teamCode ? 1 : -1))
          .toDouble();
    }).toList();
    return setsDiff;
  }

  static List<double> computeCumulativePointsDiffs(List<double> pointsDiff) {
    List<double> cumulativePointsDiff = List.generate(pointsDiff.length, (_) => 0);
    if (pointsDiff.length > 0) cumulativePointsDiff[0] = pointsDiff[0];
    for (int i = 0; i < cumulativePointsDiff.length - 1; i++) {
      cumulativePointsDiff[i + 1] = pointsDiff[i + 1] + cumulativePointsDiff[i];
    }
    return cumulativePointsDiff;
  }
}
