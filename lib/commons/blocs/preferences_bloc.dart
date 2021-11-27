import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

// ----- EVENTS -----

class PreferencesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PreferencesLoadEvent extends PreferencesEvent {}

class PreferencesSaveEvent extends PreferencesEvent {
  final bool? useAutomaticTheme;
  final bool? useDarkTheme;
  final Club? favoriteClub;
  final Team? favoriteTeam;

  PreferencesSaveEvent({this.useAutomaticTheme, this.useDarkTheme, this.favoriteClub, this.favoriteTeam});
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
  final Color? dominantColor;
  final Club? favoriteClub;
  final Team? favoriteTeam;

  PreferencesUpdatedState({
    required this.useAutomaticTheme,
    required this.useDarkTheme,
    this.dominantColor,
    this.favoriteClub,
    this.favoriteTeam,
  });
}

// ----- BLOC -----

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final Repository repository;

  PreferencesBloc(this.repository) : super(PreferencesUninitializedState());

  @override
  Stream<PreferencesState> mapEventToState(PreferencesEvent event) async* {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (event is PreferencesLoadEvent) {
      yield PreferencesLoadingState();
      Club? club = await repository.loadFavoriteClub();
      yield PreferencesUpdatedState(
        useAutomaticTheme: preferences.getBool("automatic_theme") ?? true,
        useDarkTheme: preferences.getBool("dark_theme") ?? false,
        favoriteClub: club,
      );
    } else if (event is PreferencesSaveEvent) {
      yield PreferencesSavingState();
      if (event.useAutomaticTheme != null) preferences.setBool("automatic_theme", event.useAutomaticTheme!);
      if (event.useDarkTheme != null) preferences.setBool("dark_theme", event.useDarkTheme!);
      if (event.favoriteClub?.code != null) {
        await repository.setFavorite(event.favoriteClub!.code, FavoriteType.Club);
      }
      if (event.favoriteTeam?.code != null) {
        await repository.setFavorite(event.favoriteTeam!.code, FavoriteType.Team);
      }
      yield PreferencesUpdatedState(
        useAutomaticTheme: preferences.getBool("automatic_theme") ?? true,
        useDarkTheme: preferences.getBool("dark_theme") ?? false,
        favoriteClub: event.favoriteClub,
        favoriteTeam: event.favoriteTeam,
      );
    }
  }
}
