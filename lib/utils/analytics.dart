import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:v34/utils/extensions.dart';

// A Navigator observer that notifies RouteAwares of changes to state of their Route
final routeObserver = RouteObserver<PageRoute>();

mixin RouteAwareAnalytics<T extends StatefulWidget> on State<T> implements RouteAware {
  AnalyticsRoute get route;
  String? get extraRoute => null;

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {
    // Called when the top route has been popped off,
    // and the current route shows up.
    _setCurrentScreen(route);
  }

  @override
  void didPush() {
    // Called when the current route has been pushed.
    _setCurrentScreen(route);
  }

  @override
  void didPushNext() {}

  Future<void> pushAnalyticsScreen() {
    return _setCurrentScreen(route);
  }

  Future<void> _setCurrentScreen(AnalyticsRoute analyticsRoute) {
    print("Setting current screen to ${screenName(analyticsRoute, extra: extraRoute?.snakeCase())}");
    return FirebaseAnalytics.instance.setCurrentScreen(
      screenName: screenName(analyticsRoute, extra: extraRoute?.snakeCase()),
      screenClassOverride: screenClass(analyticsRoute, extra: extraRoute.capitalize()),
    );
  }
}

enum AnalyticsRoute {
  dashboard,
  competitions,
  competitions_details,
  clubs,
  gymnasiums,
  club_statistics,
  club_teams,
  club_informations,
  team_competitions,
  team_results,
  team_agenda,
  match,
  meeting,
  tournament,
  profile,
  preferences,
  about,
  licence,
  scoreboard,
  unknown_event,
}

String screenClass(AnalyticsRoute route, {String? extra}) {
  switch (route) {
    case AnalyticsRoute.dashboard:
      return "Dashboard";
    case AnalyticsRoute.competitions:
      return "Competitions";
    case AnalyticsRoute.competitions_details:
      return "Competitions Details";
    case AnalyticsRoute.clubs:
      return "Clubs";
    case AnalyticsRoute.gymnasiums:
      return "Gymnasiums";
    case AnalyticsRoute.club_statistics:
      return "Club Statistics";
    case AnalyticsRoute.club_teams:
      return "Club Teams";
    case AnalyticsRoute.club_informations:
      return "Club Informations";
    case AnalyticsRoute.team_competitions:
      return "Team Competition ${extra ?? ""}";
    case AnalyticsRoute.team_results:
      return "Team Results";
    case AnalyticsRoute.team_agenda:
      return "Team Agenda";
    case AnalyticsRoute.match:
      return "Match";
    case AnalyticsRoute.meeting:
      return "Meeting";
    case AnalyticsRoute.tournament:
      return "Tournament";
    case AnalyticsRoute.profile:
      return "Profile";
    case AnalyticsRoute.preferences:
      return "Preferences";
    case AnalyticsRoute.about:
      return "About";
    case AnalyticsRoute.licence:
      return "Licence";
    case AnalyticsRoute.scoreboard:
      return "Scoreboard";
    case AnalyticsRoute.unknown_event:
      return "Unknown Event";
  }
}

String screenName(AnalyticsRoute route, {String? extra}) {
  switch (route) {
    case AnalyticsRoute.dashboard:
      return "/";
    case AnalyticsRoute.competitions:
      return "/competitions";
    case AnalyticsRoute.competitions_details:
      return "/competitions/details";
    case AnalyticsRoute.clubs:
      return "/clubs";
    case AnalyticsRoute.gymnasiums:
      return "/gymnasiums";
    case AnalyticsRoute.club_statistics:
      return "/club/statistics";
    case AnalyticsRoute.club_teams:
      return "/club/teams";
    case AnalyticsRoute.club_informations:
      return "/club/informations";
    case AnalyticsRoute.team_competitions:
      return "/team/competitions/${extra ?? ""}";
    case AnalyticsRoute.team_results:
      return "/team/results/${extra ?? ""}";
    case AnalyticsRoute.team_agenda:
      return "/team/agenda";
    case AnalyticsRoute.match:
      return "/match";
    case AnalyticsRoute.meeting:
      return "/meeting";
    case AnalyticsRoute.tournament:
      return "/tournament";
    case AnalyticsRoute.profile:
      return "/profile";
    case AnalyticsRoute.preferences:
      return "/preferences";
    case AnalyticsRoute.about:
      return "/about";
    case AnalyticsRoute.licence:
      return "/licence";
    case AnalyticsRoute.scoreboard:
      return "/scoreboard";
    case AnalyticsRoute.unknown_event:
      return "/unknown_event";
  }
}
