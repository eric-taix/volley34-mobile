import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ----- EVENTS -----

class PreferencesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PreferencesLoadEvent extends PreferencesEvent {}

class PreferencesSaveEvent extends PreferencesEvent {
  final bool? useAutomaticTheme;
  final bool? useDarkTheme;

  PreferencesSaveEvent({this.useAutomaticTheme, this.useDarkTheme});
}

// ----- STATES -----

class PreferencesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PreferencesUninitializedState extends PreferencesState {}

class PreferencesLoadingState extends PreferencesState {}

class PreferencesSavingState extends PreferencesState {}

class PreferencesUpdatedState extends PreferencesState {
  final bool useAutomaticTheme;
  final bool useDarkTheme;

  PreferencesUpdatedState({required this.useAutomaticTheme, required this.useDarkTheme});
}

// ----- BLOC -----

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  PreferencesBloc() : super(PreferencesUninitializedState());

  @override
  Stream<PreferencesState> mapEventToState(PreferencesEvent event) async* {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (event is PreferencesLoadEvent) {
      yield PreferencesLoadingState();
      yield PreferencesUpdatedState(
          useAutomaticTheme: preferences.getBool("automatic_theme") ?? true,
          useDarkTheme: preferences.getBool("dark_theme") ?? false);
    } else if (event is PreferencesSaveEvent) {
      yield PreferencesSavingState();
      if (event.useAutomaticTheme != null) preferences.setBool("automatic_theme", event.useAutomaticTheme!);
      if (event.useDarkTheme != null) preferences.setBool("dark_theme", event.useDarkTheme!);
      yield PreferencesUpdatedState(
          useAutomaticTheme: preferences.getBool("automatic_theme") ?? true,
          useDarkTheme: preferences.getBool("dark_theme") ?? false);
    }
  }
}
