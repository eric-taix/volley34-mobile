import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:v34/models/gymnasium.dart';
import 'package:v34/repositories/repository.dart';

// STATES

abstract class GymnasiumState extends Equatable {
  @override
  List<Object> get props => [];
}

class GymnasiumUninitializedState extends GymnasiumState {}

class GymnasiumLoadingState extends GymnasiumState {}

class GymnasiumLoadedState extends GymnasiumState {
  final Gymnasium gymnasium;

  GymnasiumLoadedState({required this.gymnasium});

  @override
  List<Object> get props => [gymnasium];
}

// EVENTS

abstract class GymnasiumEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadGymnasiumEvent extends GymnasiumEvent {
  final String? gymnasiumCode;

  LoadGymnasiumEvent({required this.gymnasiumCode});

  @override
  List<Object?> get props => [gymnasiumCode];
}

// BLOC

class GymnasiumBloc extends Bloc<GymnasiumEvent, GymnasiumState> {
  final Repository repository;

  GymnasiumBloc(this.repository, GymnasiumState initialState) : super(initialState);

  @override
  Stream<GymnasiumState> mapEventToState(GymnasiumEvent event) async* {
    if (event is LoadGymnasiumEvent) {
      yield GymnasiumLoadingState();
      Gymnasium gymnasium = await repository.loadGymnasium(event.gymnasiumCode);
      yield GymnasiumLoadedState(gymnasium: gymnasium);
    }
  }
}
