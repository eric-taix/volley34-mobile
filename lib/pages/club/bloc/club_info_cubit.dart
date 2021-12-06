import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:v34/repositories/repository.dart';

part 'club_info_state.dart';

class ClubInfoCubit extends Cubit<ClubInfoState> {
  final Repository repository;

  ClubInfoCubit({required this.repository}) : super(ClubInfoInitial());

  void loadInfo(String clubCode) async {
    emit(ClubInfoLoading());
    var teams = await repository.loadClubTeams(clubCode);
    emit(ClubInfoLoaded(teamCount: teams.length));
  }
}
