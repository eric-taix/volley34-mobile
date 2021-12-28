part of 'division_cubit.dart';

@immutable
abstract class DivisionState extends Equatable {}

class DivisionInitialState extends DivisionState {
  @override
  List<Object?> get props => [];
}

class DivisionLoadingState extends DivisionState {
  List<Object?> get props => [];
}

class DivisionLoadedState extends DivisionState implements Equatable {
  final List<Division> divisions;

  DivisionLoadedState(this.divisions);

  @override
  List<Object?> get props => [divisions];
}
