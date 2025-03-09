import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

// -- Events

class TeamRankingEvent extends Equatable {
  final Team team;

  const TeamRankingEvent(this.team);

  @override
  List<Object> get props => [team];
}

class LoadTeamRankingEvent extends TeamRankingEvent {
  LoadTeamRankingEvent(Team team) : super(team);
}

// -- States

class TeamRankingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamRankingUninitializedState extends TeamRankingState {}

class TeamRankingLoadingState extends TeamRankingState {}

class TeamRankingLoadedState extends TeamRankingState {
  final String? highlightedTeamCode;
  final List<RankingSynthesis> rankings;
  final String? firstShownCompetition;

  TeamRankingLoadedState(this.highlightedTeamCode, this.rankings, this.firstShownCompetition);

  @override
  List<Object?> get props => [highlightedTeamCode, rankings];
}

// -- Bloc

class TeamRankingBloc extends Bloc<TeamRankingEvent, TeamRankingState> {
  final Repository repository;

  TeamRankingBloc({required this.repository}) : super(TeamRankingUninitializedState()) {
    on<LoadTeamRankingEvent>((event, emit) async {
      emit(TeamRankingLoadingState());
      List<RankingSynthesis> rankings = await repository.loadTeamRankingSynthesis(event.team.code);
      rankings = rankings.map((classification) {
        classification.ranks?.sort((tc1, tc2) {
          return tc1.rank!.compareTo(tc2.rank!) * -1;
        });
        return classification;
      }).toList();

      var competitions = await repository.loadAllCompetitions();
      var teamRankingsCode = rankings.map((ranking) => ranking.competitionCode);
      var teamCompetitions = competitions.where((competition) => teamRankingsCode.contains(competition.code)).toList();
      emit(TeamRankingLoadedState(event.team.code, rankings, teamCompetitions.firstShownCompetition()?.code));
    });
  }
}

extension DateTimeExtension on DateTime {
  operator <(DateTime other) => this.compareTo(other) < 0;
  operator >(DateTime other) => this.compareTo(other) > 0;
  operator <=(DateTime other) => this.compareTo(other) <= 0;
  operator >=(DateTime other) => this.compareTo(other) >= 0;
}
