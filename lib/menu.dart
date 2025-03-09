import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/show_dialog.dart';
import 'package:v34/features_flag.dart';
import 'package:v34/message_cubit.dart';
import 'package:v34/pages/markdown_page.dart';
import 'package:v34/pages/preferences_page.dart';
import 'package:v34/pages/profil/profil_page.dart';
import 'package:v34/utils/analytics.dart';

class AppMenu extends StatefulWidget {
  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  Timer? _tapFuture;
  int _count = 0;

  _onTap(BuildContext context) {
    _tapFuture?.cancel();
    _tapFuture = Timer(Duration(milliseconds: 1000), () {
      _count = 0;
    });
    _count++;
    if (_count == 7) {
      Features.setFeature(
        context,
        experimental_features,
        true,
      );
      BlocProvider.of<MessageCubit>(context)
          .showMessage(title: "Information", message: "$experimental_features activé");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textStyleColor = Theme.of(context).textTheme.bodyMedium!.color!;
    NavigatorState navigator = Navigator.of(context);
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
                                style: Theme.of(context).textTheme.headlineMedium,
                                maxLines: 1,
                              ),
                            ),
                            state is PreferencesUpdatedState && state.favoriteClub != null
                                ? Text(
                                    state.favoriteClub!.name!,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    maxLines: 1,
                                  )
                                : SizedBox(),
                          ],
                        );
                      },
                    ),
                  ],
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
              "Profil",
              Icon(Icons.person, color: textStyleColor),
              () => navigator
                  .maybePop()
                  .then((value) => navigator.push(MaterialPageRoute<void>(builder: (context) => ProfilPage())))),
          _MenuItemWithLeading(
              "Préférences",
              Icon(Icons.settings, color: textStyleColor),
              () => navigator
                  .maybePop()
                  .then((value) => navigator.push(MaterialPageRoute<void>(builder: (context) => PreferencesPage())))),
          _MenuItemWithLeading(
              "A propos",
              Icon(FontAwesomeIcons.info, color: textStyleColor),
              () => navigator.maybePop().then((value) => navigator.push(MaterialPageRoute<void>(
                  builder: (context) => MarkdownPage(
                        "A propos",
                        "assets/about.markdown",
                        analyticsRoute: AnalyticsRoute.about,
                        child: GestureDetector(
                          onTap: () => _onTap(context),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: FutureBuilder(
                              future: PackageInfo.fromPlatform(),
                              builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                                if (snapshot.hasData) {
                                  String appName = snapshot.data?.appName ?? "?";
                                  String version = snapshot.data?.version ?? "?";
                                  String buildNumber = snapshot.data?.buildNumber ?? "?";
                                  return RichText(
                                    text: TextSpan(
                                      text: "$appName ",
                                      style: Theme.of(context).textTheme.headlineMedium,
                                      children: [
                                        TextSpan(
                                            text: "  - version $version (build $buildNumber)",
                                            style: Theme.of(context).textTheme.bodyMedium),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Version 0.0.0");
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ),
                        ),
                      ))))),
          _MenuItemWithLeading(
              "License",
              Icon(FontAwesomeIcons.ribbon, color: textStyleColor),
              () => navigator.maybePop().then((value) => navigator.push(MaterialPageRoute<void>(
                  builder: (context) => MarkdownPage(
                        "Licence",
                        "assets/gpl_licence.txt",
                        analyticsRoute: AnalyticsRoute.licence,
                      ))))),
          if (!BetterFeedback.of(context).isVisible) ...[
            Divider(),
            _MenuItemWithLeading("Soumettre un bug", Icon(Icons.bug_report_rounded, color: textStyleColor), () {
              Navigator.pop(context);
              showAlertDialog(
                context,
                "Soumettre un bug",
                "L'application va se réduire mais vous pourrez continuer à l'utiliser.\n\n"
                    "Décrivez le plus précisément possible le problème, pourquoi cela vous semble un bug, "
                    "ce que vous vous attendiez à voir. PUIS vous pouvez surligner des parties de l'écran "
                    "en cliquant sur 'Dessiner'. Cliquez enfin sur 'Envoyer' pour nous soumettre le bug.\n\n"
                    "Merci pour votre contribution",
                onPressed: (context) {
                  BetterFeedback.of(context).show(
                    (UserFeedback feedback) async {
                      final screenshotFilePath = await _writeImageToStorage(feedback.screenshot);

                      final Email email = Email(
                        body: feedback.text,
                        subject: "Volley34 Feedback",
                        recipients: ["support@volley34.fr"],
                        attachmentPaths: [screenshotFilePath],
                        isHTML: false,
                      );
                      await FlutterEmailSender.send(email);
                    },
                  );
                },
              );
            }),
          ]
        ],
      ),
    );
  }

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
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
    TextStyle textStyle = Theme.of(context).textTheme.displayLarge!;
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
