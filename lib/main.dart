import 'package:bloc/bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:v34/app_page.dart';
import 'package:v34/commons/blocs/logging_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/env.dart';
import 'package:v34/message_cubit.dart';
import 'package:v34/repositories/providers/agenda_provider.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/competition_provider.dart';
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
  var sharedPreferences = await SharedPreferences.getInstance();
  var prefThemeString = sharedPreferences.getString("theme");
  ThemeMode _themeMode =
      ThemeMode.values.firstWhere((theme) => theme.toString() == prefThemeString, orElse: () => ThemeMode.system);

  runApp(V34(themeMode: _themeMode));
}

class V34 extends StatefulWidget {
  final ThemeMode themeMode;

  V34({required this.themeMode});

  @override
  _V34State createState() => _V34State();

  static String _pkg = "mobile";

  static String? get pkg => Env.getPackage(_pkg);
}

class _V34State extends State<V34> {
  late Repository _repository;
  late MessageCubit _messageCubit;
  late ThemeMode _themeMode;
  late PreferencesBloc _preferencesBloc;

  @override
  void initState() {
    super.initState();
    _repository = Repository(ClubProvider(), TeamProvider(), FavoriteProvider(), AgendaProvider(), GymnasiumProvider(),
        MapProvider(), ResultProvider(), GlobalProvider(), CompetitionProvider());
    _preferencesBloc = PreferencesBloc(_repository)..add(PreferencesLoadEvent());

    _themeMode = widget.themeMode;

    _messageCubit = MessageCubit();
    initDio(_messageCubit);
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (BuildContext context) => _repository,
      child: BlocProvider(
        create: (_) => _preferencesBloc,
        child: BlocProvider(
          create: (_) => _messageCubit,
          child: FeatureDiscovery(
            child: BlocListener<PreferencesBloc, PreferencesState>(
              listener: (_, state) {
                if (state is PreferencesUpdatedState) {
                  setState(() {
                    _themeMode = state.themeMode;
                  });
                }
              },
              child: Features(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: BetterFeedback(
                    mode: FeedbackMode.navigate,
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalFeedbackLocalizationsDelegate(),
                    ],
                    localeOverride: const Locale('fr'),
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: "Volley34",
                      theme: AppTheme.lightTheme(),
                      darkTheme: AppTheme.darkTheme(),
                      themeMode: _themeMode,
                      home: SplashScreenView(
                        navigateRoute: AppPage(),
                        duration: 800,
                        text: "Volley 34",
                        textType: TextType.ScaleAnimatedText,
                        textStyle: TextStyle(
                            color: Color(0xFFF7FBFE), fontSize: 34, fontFamily: "Raleway", fontWeight: FontWeight.bold),
                        backgroundColor: Color(0xFF262C41),
                      ),
                      navigatorObservers: [routeObserver],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
