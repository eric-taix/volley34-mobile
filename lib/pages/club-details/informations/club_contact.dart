import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/models/club.dart';
import 'package:v34/utils/extensions.dart';

class ClubContact extends StatelessWidget {
  final Club? club;

  ClubContact({this.club});

  @override
  Widget build(BuildContext context) {
    var initial = (club!.contact.isNotNullAndNotEmpty())
        ? Text(
            club!.contact!.split(" ").take(2).map((word) => word[0].toUpperCase()).join(),
            style: Theme.of(context).textTheme.subtitle1,
          )
        : Text("");
    return TitledCard(
        icon: Icon(Icons.person, color: Theme.of(context).textTheme.headline6!.color),
        title: "Contact",
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0, left: 8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (club!.email != null && club!.email!.isNotEmpty)
                      Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: NetworkImage(
                                Gravatar(club!.contact!).imageUrl(size: 208, defaultImage: GravatarImage.blank)),
                            child: initial,
                          )),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                      child: Align(alignment: Alignment.center, child: Text(club!.contact!)),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
        actions: [
          if (club!.phone.isNotNullAndNotEmpty())
            CardAction(
              icon: Icons.phone,
              onTap: () {
                launch("tel:${club!.phone}");
              },
            ),
          if (club!.phone.isNotNullAndNotEmpty())
            CardAction(
              icon: Icons.sms,
              onTap: () {
                launch("sms:${club!.phone}");
              },
            ),
          if (club!.email.isNotNullAndNotEmpty())
            CardAction(
              icon: Icons.mail,
              onTap: () {
                launch("mailto:${club!.email}");
              },
            ),
        ]);
  }
}
