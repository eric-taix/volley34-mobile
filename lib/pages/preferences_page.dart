import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/utils/analytics.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> with RouteAwareAnalytics {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text("Préférences")),
      body: _buildPreferencesContent(),
    );
  }

  Widget _buildPreferencesContent() {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (context, state) {
        if (state is PreferencesUpdatedState) {
          return ListView(
            children: <Widget>[
              SizedBox(height: 30),
              _buildThemeOption(context, state),
              SizedBox(height: 50),
            ],
          );
        } else {
          return Center(
            child: Loading(),
          );
        }
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, PreferencesUpdatedState state) {
    String getThemeUserString(ThemeMode themeMode) {
      switch (themeMode) {
        case ThemeMode.light:
          return "Clair";
        case ThemeMode.system:
          return "Thème par défaut du système";
        case ThemeMode.dark:
          return "Sombre";
      }
    }

    return ListTile(
      title: Text("Thème", style: Theme.of(context).textTheme.bodyText2),
      subtitle: Text(getThemeUserString(state.themeMode), style: Theme.of(context).textTheme.bodyText1),
      onTap: () {
        void updateTheme(ThemeMode? themeMode) async {
          Navigator.of(context, rootNavigator: true).pop(themeMode);
          if (themeMode != null) {
            BlocProvider.of<PreferencesBloc>(context).add(PreferencesSaveEvent(themeMode: themeMode));
          }
        }

        Widget buildOption(String label, ThemeMode value) => RadioListTile<ThemeMode>(
              contentPadding: EdgeInsets.zero,
              value: value,
              groupValue: state.themeMode,
              onChanged: updateTheme,
              title: Text(label, style: Theme.of(context).textTheme.bodyText2),
            );

        showDialog<ThemeMode>(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Thème"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildOption("Clair", ThemeMode.light),
                  buildOption("Sombre", ThemeMode.dark),
                  buildOption("Theme par défaut du système", ThemeMode.system),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context, rootNavigator: true).pop(), child: Text("Annuler")),
              ],
            );
          },
        );
      },
    );
  }

/*
  Widget _buildDarkModeOption(PreferencesUpdatedState state) {
    if (state.useAutomaticTheme) {
      return ListTile(
        title: Text("Mode sombre", style: Theme.of(context).textTheme.bodyText2),
        leading: Icon(
          Icons.brightness_6,
          color: Theme.of(context).textTheme.bodyText2!.color,
        ),
        subtitle: Text(
          "Mode sombre automatique",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    } else {
      return SwitchListTile(
          title: Text("Mode sombre", style: Theme.of(context).textTheme.bodyText2),
          subtitle: Text(state.useDarkTheme ? "Mode sombre actif" : "Mode sombre inactif",
              style: Theme.of(context).textTheme.bodyText1),
          secondary: Icon(
            Icons.brightness_6,
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
          value: state.useDarkTheme,
          onChanged: (isDark) {
            BlocProvider.of<PreferencesBloc>(context).add(PreferencesSaveEvent(useDarkTheme: isDark));
          });
    }
  }

  Widget _buildAutomaticModeOption(PreferencesUpdatedState state) {
    return SwitchListTile(
      contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      title: Text("Mode sombre automatique", style: Theme.of(context).textTheme.bodyText2),
      subtitle: Text(
          "Cette option active automatiquement le mode sombre en fonction des préférences de votre appareil.",
          style: Theme.of(context).textTheme.bodyText1),
      secondary: Icon(Icons.access_time, color: Theme.of(context).textTheme.bodyText2!.color),
      value: state.useAutomaticTheme,
      onChanged: (isAutomatic) {
        BlocProvider.of<PreferencesBloc>(context).add(PreferencesSaveEvent(useAutomaticTheme: isAutomatic));
      },
    );
  }
*/
  @override
  AnalyticsRoute get route => AnalyticsRoute.preferences;
}
