import 'package:feature_flags/feature_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/features_flag.dart';
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
      backgroundColor: Theme.of(context).canvasColor,
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
              _buildForceInDashboard(context, state),
              if (Features.isFeatureEnabled(context, experimental_features)) _buildFeaturesFlag(context),
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

  Widget _buildFeaturesFlag(BuildContext context) {
    return Column(children: [
      Paragraph(
        title: "Fonctionnalités Expérimentales",
        bottomPadding: 28,
      ),
      ...FEATURES_FLAGS.map((featureFlag) {
        return ListTile(
          title: Row(
            children: [
              Expanded(child: Text(featureFlag, style: Theme.of(context).textTheme.bodyText2)),
              Switch(
                value: Features.isFeatureEnabled(context, featureFlag),
                onChanged: (value) {
                  Features.setFeature(context, featureFlag, value);
                },
              ),
            ],
          ),
        );
      }),
    ]);
  }

  Widget _buildForceInDashboard(BuildContext context, PreferencesUpdatedState state) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
              child: Text("Afficher les forces des équipes dans la liste des prochains événements",
                  style: Theme.of(context).textTheme.bodyText2)),
          Switch(
              value: state.showForceOnDashboard ?? false,
              onChanged: (value) {
                BlocProvider.of<PreferencesBloc>(context).add(PreferencesSaveEvent(showForceOnDashboard: value));
              }),
        ],
      ),
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

  @override
  AnalyticsRoute get route => AnalyticsRoute.preferences;
}
