import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/loading.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
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
              _buildDarkModeOption(state),
              Divider(height: 1.0),
              _buildAutomaticModeOption(state),
            ],
          );
        } else {
          return Center(
            child: Column(children: <Widget>[Text("Chargement de vos préférences..."), Loading()]),
          );
        }
      },
    );
  }

  Widget _buildDarkModeOption(PreferencesUpdatedState state) {
    if (state.useAutomaticTheme) {
      return ListTile(
        title: Text("Mode sombre", style: Theme.of(context).textTheme.bodyText2),
        leading: Icon(
          Icons.brightness_6,
          color: Theme.of(context).accentColor,
        ),
        subtitle: Text(
          "Mode sombre automatique",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 10),
        ),
      );
    } else {
      return SwitchListTile(
          title: Text("Mode sombre", style: Theme.of(context).textTheme.bodyText2),
          subtitle: Text(state.useDarkTheme ? "Mode sombre actif" : "Mode sombre inactif",
              style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 10)),
          secondary: Icon(
            Icons.brightness_6,
            color: Theme.of(context).accentColor,
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
          style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 10)),
      secondary: Icon(Icons.access_time, color: Theme.of(context).accentColor),
      value: state.useAutomaticTheme,
      onChanged: (isAutomatic) {
        BlocProvider.of<PreferencesBloc>(context).add(PreferencesSaveEvent(useAutomaticTheme: isAutomatic));
      },
    );
  }
}
