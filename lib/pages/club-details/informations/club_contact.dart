import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v34/commons/paragraph.dart';
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
    return Column(
      children: [
        Paragraph(
          title: "Contact",
          topPadding: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0, right: 18.0, bottom: 18.0, left: 18.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (club!.email != null && club!.email!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage:
                          NetworkImage(Gravatar(club!.contact!).imageUrl(size: 208, defaultImage: GravatarImage.blank)),
                      child: initial,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                  child: Align(alignment: Alignment.center, child: Text(club!.contact!)),
                ),
              ],
            ),
          ]),
        ),
        _buildClubInfo(context, label: "Site web", icon: FontAwesomeIcons.globe, value: club!.websiteUrl),
        _buildClubInfo(context, label: "Facebook", icon: FontAwesomeIcons.facebook, value: club!.facebook),
        _buildClubInfo(context, label: "Twitter", icon: FontAwesomeIcons.twitter, value: club!.twitter),
        _buildClubInfo(context, label: "Instagram", icon: FontAwesomeIcons.instagram, value: club!.instagram),
        _buildClubInfo(context, label: "Snapchat", icon: FontAwesomeIcons.snapchat, value: club!.snapchat),
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (club!.phone.isNotNullAndNotEmpty())
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: "hero-btn-club-tel",
                    mini: true,
                    onPressed: () => launch("tel:${club!.phone}"),
                    child: Icon(Icons.phone),
                  ),
                ),
              if (club!.phone.isNotNullAndNotEmpty())
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: "hero-btn-club-sms",
                    mini: true,
                    onPressed: () => launch("sms:${club!.phone}"),
                    child: Icon(Icons.sms),
                  ),
                ),
              if (club!.email.isNotNullAndNotEmpty())
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FloatingActionButton(
                    heroTag: "hero-btn-club-mail",
                    mini: true,
                    onPressed: () => launch("mailto:${club!.email}"),
                    child: Icon(Icons.mail),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClubInfo(BuildContext context,
          {required String label, required IconData icon, required String? value}) =>
      value.isNotNullAndNotEmpty()
          ? Padding(
              padding: EdgeInsets.only(left: 48, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, color: Theme.of(context).textTheme.bodyText1!.color),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(label),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: TextButton(child: Text("Visitez"), onPressed: () => launch(value!)),
                  ),
                ],
              ),
            )
          : SizedBox();
}
