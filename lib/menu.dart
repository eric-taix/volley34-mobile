import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/pages/markdown_page.dart';
import 'package:v34/pages/preferences_page.dart';

class AppMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigatorState navigator = Navigator.of(context);
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(
              image: AssetImage("assets/logo.png"),
              width: 80,
            ),
            Text("VOLLEY 34", style: Theme.of(context).textTheme.headline4),
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.color,
        ),
      ),
      SizedBox(
        height: 30,
      ),
      _MenuItemWithLeading(
          "Préférences",
          Icons.settings,
          () => navigator.maybePop().then((value) => navigator.push(MaterialPageRoute<void>(
              builder: (context) => PreferencesPage())))),
      _MenuItemWithLeading(
          "A propos",
          FontAwesomeIcons.info,
          () => navigator.maybePop().then((value) => navigator.push(MaterialPageRoute<void>(
              builder: (context) =>
                  MarkdownPage("A propos", "assets/about.markdown"))))),
      _MenuItemWithLeading(
          "License",
          FontAwesomeIcons.ribbon,
          () => navigator.maybePop().then((value) => navigator.push(MaterialPageRoute<void>(
              builder: (context) =>
                  MarkdownPage("Licence", "assets/gpl_licence.txt"))))),
    ]));
  }
}

class _MenuItemWithLeading extends StatelessWidget {
  final String data;
  final IconData leadingIcon;
  final Function() onTap;

  _MenuItemWithLeading(this.data, this.leadingIcon, this.onTap);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline1;
    return ListTile(
      leading: Icon(leadingIcon, color: textStyle.color),
      title: Text(data, style: textStyle),
      onTap: onTap,
      trailing: Icon(Icons.keyboard_arrow_right, color: textStyle.color,),
    );
  }
}
