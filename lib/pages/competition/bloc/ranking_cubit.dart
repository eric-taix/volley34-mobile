import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:v34/models/division.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/pages/competition/competition_filter.dart';
import 'package:v34/repositories/repository.dart';

part 'ranking_state.dart';

class RankingCubit extends Cubit<RankingState> {
  final Repository repository;

  RankingCubit(this.repository) : super(RankingInitialState());

  void loadAllRankings(CompetitionFilter? filter) async {
    emit(RankingLoadingState());
    var rankings = await repository.loadAllRankingSynthesis();
    if (filter != null) {
      rankings = rankings
          .where((ranking) =>
              filter.competitionDivision == Division.all || filter.competitionDivision.code == ranking.division)
          .where((ranking) =>
              filter.competitionGroup == CompetitionFilter.ALL_COMPETITION ||
              ranking.competitionCode!.startsWith(filter.competitionGroup))
          .toList();
    }
    emit(RankingLoadedState(rankings));
  }
}
