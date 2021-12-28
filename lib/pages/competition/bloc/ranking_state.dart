part of 'ranking_cubit.dart';

abstract class RankingState extends Equatable {
  const RankingState();
}

class RankingInitialState extends RankingState {
  @override
  List<Object> get props => [];
}

class RankingLoadingState extends RankingState {
  @override
  List<Object> get props => [];
}

class RankingLoadedState extends RankingState {
  final List<RankingSynthesis> rankings;

  RankingLoadedState(this.rankings);

  @override
  List<Object> get props => [rankings];
}
