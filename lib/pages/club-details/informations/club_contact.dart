

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v34/commons/card/titled_card.dart';
import 'package:v34/models/club.dart';
import 'package:v34/utils/extensions.dart';
import 'package:v34/utils/launch.dart';

class ClubContact extends StatelessWidget {

  final Club club;

  ClubContact({this.club});

  @override
  Widget build(BuildContext context) {
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
              icon: Icons.phone,
              onTap: () {
                launch("tel:${club.phone}");
              },
            ),
          if (club.phone.isNotNullAndNotEmpty())
            CardAction(
              icon: Icons.sms,
              onTap: () {
                launch("sms:${club.phone}");
              },
            ),
          if (club.email.isNotNullAndNotEmpty())
            CardAction(
              icon: Icons.mail,
              onTap: () {
                launch("mailto:${club.email}");
              },
            ),
        ]);
  }

}