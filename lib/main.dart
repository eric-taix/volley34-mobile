import 'package:bloc/bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
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

Future<void> main() async {
  Bloc.observer = LoggingBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FutureBuilder(
    future: SharedPreferences.getInstance(),
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
      bool _automatic = true;
      bool _dark = true;
      if (snapshot.hasData) {
        _automatic = snapshot.data!.getBool("automatic_theme") ?? true;
        _dark = snapshot.data!.getBool("dark_theme") ?? false;
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

  @override
  void initState() {
    super.initState();

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
            child: MaterialApp(
              title: 'Volley34',
              theme: AppTheme.getNormalThemeFromPreferences(widget.automatic, widget.dark),
              darkTheme: AppTheme.getDarkThemeFromPreferences(widget.automatic),
              home: MainPage(),
            ),
          ),
        ),
      ),
    );
  }
}
