import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/theme.dart';

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
      bloc: BlocProvider.of<PreferencesBloc>(context),
      builder: (context, state) {
        if (state is PreferencesLoadedState) {
          return ListView.builder(
            itemBuilder: (context, index) => _buildPreferencesItem(index, state),
          );
        } else {
          return Center(
            child: Column(
                children: <Widget>[
                  Text("Chargement de vos préférences..."),
                  Loading()
                ]
            ),
          );
        }
      },
    );
  }

  Widget _buildPreferencesItem(int index, PreferencesLoadedState state) {
    if (index % 2 == 0) {
      index = index ~/ 2;
      switch (index) {
        case 0:
          if (state.automaticDarkTheme) {
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
              value: state.darkTheme,
              onChanged: (dark) {
                BlocProvider.of<PreferencesBloc>(context).add(PreferencesSaveEvent(darkTheme: dark));
              }
            );
          }
          break;
        case 1:
          return SwitchListTile(
            contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            title: Text("Mode sombre automatique", style: Theme.of(context).textTheme.bodyText2),
            subtitle: Text(
                "Cette option active automatiquement le mode sombre en fonction des préférences de votre appareil.",
                style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: 10)
            ),
            secondary: Icon(Icons.access_time, color: Theme.of(context).accentColor),
            value: state.automaticDarkTheme,
            onChanged: (automatic) {
              BlocProvider.of<PreferencesBloc>(context).add(PreferencesSaveEvent(automaticDarkTheme: automatic));
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