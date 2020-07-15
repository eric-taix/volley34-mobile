import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ----- EVENTS -----

class PreferencesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PreferencesLoadEvent extends PreferencesEvent {}

class PreferencesSaveEvent extends PreferencesEvent {
  final bool automaticDarkTheme;
  final bool darkTheme;

  PreferencesSaveEvent({this.automaticDarkTheme, this.darkTheme});
}

// ----- STATES -----

class PreferencesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PreferencesUninitializedState extends PreferencesState {}

class PreferencesLoadingState extends PreferencesState {}

class PreferencesSavingState extends PreferencesState {}

class PreferencesLoadedState extends PreferencesState {
  final bool automaticDarkTheme;
  final bool darkTheme;

  PreferencesLoadedState({@required this.automaticDarkTheme, @required this.darkTheme});
}

class PreferencesSavedState extends PreferencesState {}

// ----- BLOC -----

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  SharedPreferences _preferences;

  Future<SharedPreferences> _getPreferences() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _preferences;
  }

  @override
  PreferencesState get initialState => PreferencesUninitializedState();

  @override
  Stream<PreferencesState> mapEventToState(PreferencesEvent event) async* {
    if (event is PreferencesLoadEvent) {
      yield PreferencesLoadingState();
      SharedPreferences preferences = await _getPreferences();
      yield PreferencesLoadedState(
        automaticDarkTheme: preferences.getBool("automatic_dark_theme"),
        darkTheme: preferences.getBool("dark_theme")
      );
    } else if (event is PreferencesSaveEvent) {
      yield PreferencesSavingState();
      SharedPreferences preferences = await _getPreferences();
      if (event.automaticDarkTheme != null)
        preferences.setBool("automatic_dark_theme", event.automaticDarkTheme);
      if (event.darkTheme != null)
        preferences.setBool("dark_theme", event.darkTheme);
      yield PreferencesSavedState();
    }
  }
}