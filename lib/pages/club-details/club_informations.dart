import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v34/commons/card/card.dart';
import 'package:v34/models/club.dart';
import 'package:v34/utils/extensions.dart';
import 'package:v34/utils/launch.dart';

class ClubInformations extends StatelessWidget {
  final Club club;

  ClubInformations(this.club);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return TitledCard(
        icon: Icon(Icons.person, color: Theme.of(context).textTheme.headline6.color),
        title: "Contact",
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0, left: 8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (club.contact.isNotNullAndNotEmpty() != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                    child: Align(alignment: Alignment.center, child: Text(club.contact)),
                  ),
              ]),
            ),
          ],
        ),
        actions: [
          if (club.phone.isNotNullAndNotEmpty())
            CardAction(
              icon: FontAwesomeIcons.phone,
              iconColor: Colors.green,
              onTap: () {
                launch("tel:${club.phone}");
              },
            ),
          if (club.phone.isNotNullAndNotEmpty())
            CardAction(
              icon: FontAwesomeIcons.commentDots,
              iconColor: Colors.orangeAccent,
              onTap: () {
                launch("sms:${club.phone}");
              },
            ),
          if (club.email.isNotNullAndNotEmpty())
            CardAction(
              icon: FontAwesomeIcons.envelope,
              iconColor: Colors.redAccent,
              onTap: () {
                launch("mailto:${club.email}");
              },
            ),
          if (club.websiteUrl.isNotNullAndNotEmpty())
            CardAction(
              icon: FontAwesomeIcons.globe,
              iconColor: Colors.orangeAccent,
              onTap: () => launchURL(club.websiteUrl),
            ),
          if (club.facebook.isNotNullAndNotEmpty())
            CardAction(
              icon: FontAwesomeIcons.facebook,
              iconColor: Color(0xFF4064AD),
              onTap: () => launchURL(club.facebook),
            ),
          if (club.twitter.isNotNullAndNotEmpty())
            CardAction(
              icon: FontAwesomeIcons.twitter,
              iconColor: Color(0xFF1D9DEB),
              onTap: () => launchURL(club.twitter),
            ),
        ]);
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
