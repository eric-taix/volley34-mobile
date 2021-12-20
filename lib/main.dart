import 'package:bloc/bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v34/commons/blocs/logging_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/env.dart';
import 'package:v34/main_page.dart';
import 'package:v34/message_cubit.dart';
import 'package:v34/repositories/providers/agenda_provider.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/global_provider.dart';
import 'package:v34/repositories/providers/gymnasium_provider.dart';
import 'package:v34/repositories/providers/http.dart';
import 'package:v34/repositories/providers/map_provider.dart';
import 'package:v34/repositories/providers/result_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/theme.dart';
import 'package:v34/utils/analytics.dart';

Future<void> main() async {
  Bloc.observer = LoggingBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FutureBuilder(
    future: SharedPreferences.getInstance(),
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
      bool _automatic = true;
      bool _dark = true;
      if (snapshot.hasData) {
        _automatic = snapshot.data!.getBool("automatic_theme") ?? false;
        _dark = snapshot.data!.getBool("dark_theme") ?? true;
        return V34(automatic: _automatic, dark: _dark);
      } else {
        return SizedBox();
      }
    },
  ));
}

class V34 extends StatefulWidget {
  final bool automatic;
  final bool dark;

  V34({required this.automatic, required this.dark});

  @override
  _V34State createState() => _V34State();

  static String _pkg = "mobile";

  static String? get pkg => Env.getPackage(_pkg);
}

class _V34State extends State<V34> {
  late Repository _repository;
  late MessageCubit _messageCubit;
  late bool _automatic;
  late bool _dark;

  @override
  void initState() {
    super.initState();
    _automatic = widget.automatic;
    _dark = widget.dark;

    _messageCubit = MessageCubit();
    initDio(_messageCubit);
    _repository = Repository(
      ClubProvider(),
      TeamProvider(),
      FavoriteProvider(),
      AgendaProvider(),
      GymnasiumProvider(),
      MapProvider(),
      ResultProvider(),
      GlobalProvider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (BuildContext context) => _repository,
      child: BlocProvider(
        create: (BuildContext context) {
          PreferencesBloc preferencesBloc = PreferencesBloc(_repository);
          preferencesBloc.add(PreferencesLoadEvent());
          return preferencesBloc;
        },
        child: BlocProvider(
          create: (_) => _messageCubit,
          child: FeatureDiscovery(
            recordStepsInSharedPreferences: false,
            child: BlocProvider<PreferencesBloc>(
              create: (context) {
                PreferencesBloc bloc = PreferencesBloc(_repository);
                bloc.add(PreferencesLoadEvent());
                return bloc;
              },
              child: BlocListener<PreferencesBloc, PreferencesState>(
                listener: (context, state) {
                  if (state is PreferencesUpdatedState) {
                    setState(() {
                      _automatic = state.useAutomaticTheme;
                      _dark = state.useDarkTheme;
                    });
                  }
                },
                child: MaterialApp(
                  title: "Volley34",
                  theme: AppTheme.getNormalThemeFromPreferences(_automatic, _dark),
                  darkTheme: AppTheme.getDarkThemeFromPreferences(_automatic),
                  home: MainPage(),
                  navigatorObservers: [routeObserver],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
