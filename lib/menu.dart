import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/pages/favorite/favorite_wizard.dart';
import 'package:v34/pages/markdown_page.dart';
import 'package:v34/pages/preferences_page.dart';

class AppMenu extends StatefulWidget {
  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  @override
  Widget build(BuildContext context) {
    Color textStyleColor = Theme.of(context).textTheme.headline1!.color!;
    NavigatorState navigator = Navigator.of(context);
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<PreferencesBloc, PreferencesState>(
                  builder: (_, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        state is PreferencesUpdatedState
                            ? state.favoriteClub != null
                                ? CachedNetworkImage(
                                    imageUrl: state.favoriteClub!.logoUrl!,
                                    width: 80,
                                    height: 80,
                                  )
                                : Image(
                                    image: AssetImage("assets/logo.png"),
                                    width: 80,
                                  )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            state is PreferencesUpdatedState && state.favoriteTeam != null
                                ? state.favoriteTeam!.name!
                                : "VOLLEY 34",
                            style: Theme.of(context).textTheme.headline4,
                            maxLines: 1,
                          ),
                        ),
                        state is PreferencesUpdatedState && state.favoriteClub != null
                            ? Text(
                                state.favoriteClub!.name!,
                                style: Theme.of(context).textTheme.bodyText1,
                                maxLines: 1,
                              )
                            : SizedBox(),
                      ],
                    );
                  },
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: FloatingActionButton(
                mini: true,
                child: Icon(Icons.edit),
                onPressed: () => showGeneralDialog(
                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                  barrierColor: Colors.black45,
                  context: context,
                  pageBuilder:
                      (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
                          SelectFavoriteTeam(),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      _MenuItemWithLeading(
          "Préférences",
          Icon(Icons.settings, color: textStyleColor),
          () => navigator
              .maybePop()
              .then((value) => navigator.push(MaterialPageRoute<void>(builder: (context) => PreferencesPage())))),
      _MenuItemWithLeading(
          "A propos",
          Icon(FontAwesomeIcons.info, color: textStyleColor),
          () => navigator.maybePop().then((value) => navigator
              .push(MaterialPageRoute<void>(builder: (context) => MarkdownPage("A propos", "assets/about.markdown"))))),
      _MenuItemWithLeading(
          "License",
          Icon(FontAwesomeIcons.ribbon, color: textStyleColor),
          () => navigator.maybePop().then((value) => navigator
              .push(MaterialPageRoute<void>(builder: (context) => MarkdownPage("Licence", "assets/gpl_licence.txt"))))),
    ]));
  }
}

class _MenuItemWithLeading extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget leadingIcon;
  final Function()? onTap;

  _MenuItemWithLeading(this.title, this.leadingIcon, this.onTap, {this.subTitle});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline1!;
    return ListTile(
      leading: leadingIcon,
      title: Text(title, style: textStyle),
      subtitle: subTitle != null ? Text(subTitle!) : null,
      onTap: onTap,
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: textStyle.color,
      ),
    );
  }
}
