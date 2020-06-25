import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

// -- Events

class TeamClassificationEvent extends Equatable {
  final Team team;

  const TeamClassificationEvent(this.team) : assert(team != null);

  @override
  List<Object> get props => [team];
}

class TeamClassificationLoadEvent extends TeamClassificationEvent {
  TeamClassificationLoadEvent(Team team) : super(team);
}

// -- States

class TeamClassificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class TeamClassificationUninitializedState extends TeamClassificationState {}

class TeamClassificationLoadingState extends TeamClassificationState {}

class TeamClassificationLoadedState extends TeamClassificationState {
  final String highlightedTeamCode;
  final List<ClassificationSynthesis> classifications;

  TeamClassificationLoadedState(this.highlightedTeamCode, this.classifications);

  @override
  List<Object> get props => [highlightedTeamCode, classifications];
}

// -- Bloc

class TeamClassificationBloc extends Bloc<TeamClassificationEvent, TeamClassificationState> {
  final Repository repository;

  TeamClassificationBloc({@required this.repository});

  @override
  TeamClassificationState get initialState => TeamClassificationUninitializedState();

  @override
  Stream<TeamClassificationState> mapEventToState(TeamClassificationEvent event) async* {
    if (event is TeamClassificationLoadEvent) {
      yield TeamClassificationLoadingState();
      List<ClassificationSynthesis> classifications = await repository.loadTeamClassificationSynthesis(event.team.code);
      classifications = classifications.map((classification) {
        classification.teamsClassifications.sort((tc1, tc2) {
          return tc1.rank.compareTo(tc2.rank) * -1;
        });
        return classification;
      }).toList();
      yield TeamClassificationLoadedState(event.team.code, classifications);
    }
  }

}