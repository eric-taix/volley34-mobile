part of 'competition_cubit.dart';

abstract class CompetitionState extends Equatable {
  const CompetitionState();
}

class CompetitionInitialState extends CompetitionState {
  @override
  List<Object> get props => [];
}

class CompetitionLoadingState extends CompetitionState {
  @override
  List<Object> get props => [];
}

class CompetitionLoadedState extends CompetitionInitialState {
  final List<Competition> competitions;

  CompetitionLoadedState(this.competitions);

  @override
  List<Object> get props => [competitions];
}

class CompetitionTeamLoadedState extends CompetitionInitialState {
  final List<TeamCompetition> competitions;

  CompetitionTeamLoadedState(this.competitions);

  @override
  List<Object> get props => [competitions];
}
