import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:v34/models/division.dart';
import 'package:v34/repositories/repository.dart';

part 'division_state.dart';

class DivisionCubit extends Cubit<DivisionState> {
  final Repository repository;

  DivisionCubit(this.repository) : super(DivisionInitialState());

  void loadDivisions() async {
    emit(DivisionLoadingState());
    List<Division> divisions = await repository.loadDivisions();
    emit(DivisionLoadedState(divisions));
  }
}
