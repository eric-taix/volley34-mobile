import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/repository.dart';

// EVENTS

abstract class ClubEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadClubEvent extends ClubEvent {
  final String? clubCode;

  LoadClubEvent({required this.clubCode});

  @override
  List<Object?> get props => [clubCode];
}

// STATES

abstract class ClubState extends Equatable {
  @override
  List<Object> get props => [];
}

class ClubUninitializedState extends ClubState {}

class ClubLoadingState extends ClubState {}

class ClubLoadedState extends ClubState {
  final Club club;

  ClubLoadedState({required this.club});
}

// BLOC

class ClubBloc extends Bloc<ClubEvent, ClubState> {
  final Repository repository;

  ClubBloc(ClubState initialState, {required this.repository}) : super(initialState) {
    on<LoadClubEvent>((event, emit) async {
      emit(ClubLoadingState());
      Club club = await repository.loadClub(event.clubCode);
      emit(ClubLoadedState(club: club));
    });
  }
}
