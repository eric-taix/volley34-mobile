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
              return SwitchListTile(
                title: Text("Thème sombre", style: Theme.of(context).textTheme.bodyText2),
                secondary: Icon(Icons.brightness_6, color: Theme.of(context).accentColor,),
                value: snapshot.data.getBool('dark_theme') ?? false,
                onChanged: (dark) {
                  if (dark) {
                    ThemeSwitcher.of(context).changeTheme(theme: AppTheme.darkTheme());
                  } else {
                    ThemeSwitcher.of(context).changeTheme(theme: AppTheme.lightTheme());
                  }
                  snapshot.data.setBool('dark_theme', dark);
                },
              );
            },
          );
        default:
          return null;
      }
    } else {
      return Divider();
    }
  }

}