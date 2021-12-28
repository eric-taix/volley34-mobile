import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/repositories/repository.dart';

part 'competition_state.dart';

class CompetitionCubit extends Cubit<CompetitionState> {
  final Repository repository;

  CompetitionCubit(this.repository) : super(CompetitionInitialState());

  void loadCompetitions() async {
    emit(CompetitionLoadingState());
    var competitions = await repository.loadAllCompetitions();
    emit(CompetitionLoadedState(competitions));
  }
}
