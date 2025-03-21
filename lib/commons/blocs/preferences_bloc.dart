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

class PreferencesLoadEvent extends PreferencesEvent {
  PreferencesLoadEvent();
}

class PreferencesSaveEvent extends PreferencesEvent {
  final ThemeMode? themeMode;
  final Club? favoriteClub;
  final Team? favoriteTeam;
  final bool? showForceOnDashboard;

  PreferencesSaveEvent({this.themeMode, this.favoriteClub, this.favoriteTeam, this.showForceOnDashboard});
}

// ----- STATES -----

class PreferencesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PreferencesUninitializedState extends PreferencesState {}

class PreferencesErrorState extends PreferencesState {}

class PreferencesLoadingState extends PreferencesState {}

class PreferencesSavingState extends PreferencesState {}

class PreferencesUpdatedState extends PreferencesState {
  final ThemeMode themeMode;
  final Color? dominantColor;
  final Club? favoriteClub;
  final Team? favoriteTeam;
  final bool? showForceOnDashboard;

  PreferencesUpdatedState({
    required this.themeMode,
    this.dominantColor,
    this.favoriteClub,
    this.favoriteTeam,
    this.showForceOnDashboard,
  });
}

// ----- BLOC -----

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final Repository repository;

  PreferencesBloc(this.repository) : super(PreferencesUninitializedState()) {
    on<PreferencesLoadEvent>((event, emit) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      try {
        emit(PreferencesLoadingState());
        Club? club = await repository.loadFavoriteClub();
        Team? team = await repository.loadFavoriteTeam();
        String themeString = preferences.getString("theme") ?? "";
        bool showForceOnDashboard = preferences.getBool("showForceOnDashboard") ?? false;
        emit(
          PreferencesUpdatedState(
            themeMode:
                ThemeMode.values.firstWhere((theme) => theme.toString() == themeString, orElse: () => ThemeMode.system),
            favoriteClub: club,
            favoriteTeam: team,
            showForceOnDashboard: showForceOnDashboard,
          ),
        );
      } catch (e) {
        emit(PreferencesErrorState());
      }
    });
    on<PreferencesSaveEvent>((event, emit) async {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      try {
        emit(PreferencesSavingState());
        //await Future.delayed(Duration(milliseconds: 500), () => null);
        if (event.themeMode != null) preferences.setString("theme", event.themeMode.toString());
        if (event.favoriteClub?.code != null) {
          await repository.setFavorite(event.favoriteClub!.code, FavoriteType.Club);
        }
        if (event.favoriteTeam?.code != null) {
          await repository.setFavorite(event.favoriteTeam!.code, FavoriteType.Team);
        }
        if (event.showForceOnDashboard != null) {
          await preferences.setBool("showForceOnDashboard", event.showForceOnDashboard!);
        }
        String themeString = preferences.getString("theme") ?? "";
        emit(
          PreferencesUpdatedState(
            themeMode:
                ThemeMode.values.firstWhere((theme) => theme.toString() == themeString, orElse: () => ThemeMode.system),
            favoriteClub: event.favoriteClub ?? await repository.loadFavoriteClub(),
            favoriteTeam: event.favoriteTeam ?? await repository.loadFavoriteTeam(),
            showForceOnDashboard: event.showForceOnDashboard ?? preferences.getBool("showForceOnDashboard") ?? false,
          ),
        );
      } catch (e) {
        emit(PreferencesErrorState());
      }
    });
  }
}
