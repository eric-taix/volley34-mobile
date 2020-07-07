import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/theme.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  Future<SharedPreferences> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(title: Text("Préférences")),
        body: _buildPreferencesContent(),
      ),
    );
  }

  Widget _buildPreferencesContent() {
    return FutureBuilder<SharedPreferences>(
      future: _preferences,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Chargement de vos préférences..."),
                  Loading()
                ]
              ),
            );
          case ConnectionState.done:
            return ListView.builder(
              itemBuilder: (context, index) => _buildPreferencesItem(index, snapshot),
            );
          default:
            return Container();
        }
      },
    );
  }

  Widget _buildPreferencesItem(int index, AsyncSnapshot<SharedPreferences> snapshot) {
    if (index % 2 == 0) {
      index = index ~/ 2;
      switch (index) {
        case 0:
          return ThemeSwitcher(
            clipper: ThemeSwitcherCircleClipper(),
            builder: (context) {
              bool automaticDarkTheme = snapshot.data.getBool('automatic_dark_theme') ?? false;
              if (automaticDarkTheme) {
                return ListTile(
                  title: Text("Mode sombre", style: Theme.of(context).textTheme.bodyText2),
                  leading: Icon(Icons.brightness_6, color: Theme.of(context).accentColor,),
                  trailing: Text(
                    "Mode sombre automatique activé",
                    style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 10),
                  ),
                );
              } else {
                return SwitchListTile(
                  title: Text("Mode sombre", style: Theme.of(context).textTheme.bodyText2),
                  secondary: Icon(Icons.brightness_6, color: Theme.of(context).accentColor,),
                  value: snapshot.data.getBool('dark_theme') ?? false,
                  onChanged: (dark) {
                    if (dark) ThemeSwitcher.of(context).changeTheme(theme: AppTheme.darkTheme());
                    else ThemeSwitcher.of(context).changeTheme(theme: AppTheme.lightTheme());
                    snapshot.data.setBool('dark_theme', dark);
                  }
                );
              }
            },
          );
        case 1:
          return ThemeSwitcher(
            clipper: ThemeSwitcherCircleClipper(),
            builder: (context) {
              return SwitchListTile(
                contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                title: Text("Mode sombre automatique", style: Theme.of(context).textTheme.bodyText2),
                subtitle: Text(
                  "Cette option active automatiquement le mode sombre le soir et le désactive le matin.",
                    style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 10)
                ),
                secondary: Icon(Icons.access_time, color: Theme.of(context).accentColor),
                value: snapshot.data.getBool('automatic_dark_theme') ?? false,
                onChanged: (automatic) {
                  bool dark = snapshot.data.getBool("dark_theme") ?? false;
                  ThemeData theme = AppTheme.getThemeFromPreferences(automatic, dark);
                  ThemeSwitcher.of(context).changeTheme(theme: theme);
                  snapshot.data.setBool('automatic_dark_theme', automatic);
                },
              );
            },
          );
        default:
          return null;
      }
    } else {
      return Divider(height: 1.0);
    }
  }

}