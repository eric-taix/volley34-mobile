import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  TeamRankingLoadedState(this.highlightedTeamCode, this.rankings);

  @override
  List<Object?> get props => [highlightedTeamCode, rankings];
}

// -- Bloc

class TeamRankingBloc extends Bloc<TeamRankingEvent, TeamRankingState> {
  final Repository repository;

  TeamRankingBloc({required this.repository}) : super(TeamRankingUninitializedState());

  @override
  Stream<TeamRankingState> mapEventToState(TeamRankingEvent event) async* {
    if (event is LoadTeamRankingEvent) {
      yield TeamRankingLoadingState();
      List<RankingSynthesis> rankings = await repository.loadTeamRankingSynthesis(event.team.code);
      rankings = rankings.map((classification) {
        classification.ranks?.sort((tc1, tc2) {
          return tc1.rank!.compareTo(tc2.rank!) * -1;
        });
        return classification;
      }).toList();
      yield TeamRankingLoadedState(event.team.code, rankings);
    }
  }
}
