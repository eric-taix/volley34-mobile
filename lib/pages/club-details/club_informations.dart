import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/club.dart';
import 'package:v34/utils/extensions.dart';
import 'package:v34/utils/launch.dart';

class ClubInformations extends StatelessWidget {
  final Club club;

  ClubInformations(this.club);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 38.0, left: 10.0, right: 10.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 28.0, left: 8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 28.0, left: 8.0),
                      child: Text("Contact", style: textTheme.headline6),
                    ),
                    if (club.contact.isNotNullAndNotEmpty() != null)
                      Tile(leadingIcon: Icon(Icons.person, color: textTheme.bodyText2.color), title: club.contact),
                    if (club.websiteUrl.isNotNullAndNotEmpty())
                      Tile(
                        leadingIcon: FaIcon(FontAwesomeIcons.globe, color: textTheme.bodyText2.color),
                        title: club.websiteUrl,
                        url: club.websiteUrl,
                      ),
                    if (club.facebook.isNotNullAndNotEmpty())
                      Tile(
                        leadingIcon: FaIcon(FontAwesomeIcons.facebook, color: textTheme.bodyText2.color),
                        title: club.facebook,
                        url: club.facebook,
                      ),
                    if (club.twitter.isNotNullAndNotEmpty())
                      Tile(
                        leadingIcon: FaIcon(FontAwesomeIcons.twitter, color: textTheme.bodyText2.color),
                        title: club.twitter,
                        url: club.twitter,
                      ),
                  ]),
                ),
                Container(
                  color: Colors.white,
                  child: ButtonBar(
                    children: <Widget>[
                      if (club.phone.isNotNullAndNotEmpty())
                        FlatButton(
                          child: Icon(Icons.phone, color: Theme.of(context).cardTheme.color),
                          onPressed: () {
                            launch("tel:${club.phone}");
                          },
                        ),
                      if (club.phone.isNotNullAndNotEmpty())
                        FlatButton(
                          child: Icon(Icons.sms, color: Theme.of(context).cardTheme.color),
                          onPressed: () {
                            launch("sms:${club.phone}");
                          },
                        ),
                      if (club.email.isNotNullAndNotEmpty())
                        FlatButton(
                          child: Icon(Icons.mail, color: Theme.of(context).cardTheme.color),
                          onPressed: () {
                            launch("mailto:${club.email}");
                          },
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final url;
  Tile({this.leadingIcon, this.title, this.url});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: url != null ? () => launchURL(url) : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: leadingIcon,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(title.trim(), overflow: TextOverflow.ellipsis, style: textTheme.bodyText2.copyWith()),
            ),
          ),
          if (url != null) FaIcon(FontAwesomeIcons.externalLinkAlt, size: 14, color: Theme.of(context).textTheme.bodyText2.color)
        ]),
      ),
    );
  }
}
