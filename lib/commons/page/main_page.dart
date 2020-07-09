import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:v34/pages/preferences_page.dart';

class MainPage extends StatelessWidget {
  final String title;
  final Widget sliver;

  MainPage({this.title = "", this.sliver});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          snap: false,
          floating: true,
          centerTitle: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
          title: Text(title),
          actions: <Widget>[IconButton(icon: Icon(Icons.settings), onPressed: () => _gotoPreferencesPage(context))],
        ),
        sliver
      ],
    );
  }

  void _gotoPreferencesPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => PreferencesPage()));
  }
}
