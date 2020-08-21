import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/cards/rounded_title_card.dart';
import 'package:v34/commons/favorite/favorite_icon.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';

class ClubCard extends StatefulWidget {
  final Club club;
  final int index;

  ClubCard(this.club, this.index);

  @override
  _ClubCardState createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: RoundedTitledCard(
        title: widget.club.shortName,
        heroTag: "hero-logo-${widget.club.code}",
        logoUrl: widget.club.logoUrl,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            widget.club.name,
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () => Router.push(
                context: context, builder: (_) => ClubDetailPage(widget.club))
            .then((_) => setState(() {
                  _favorite = !_favorite;
                })),
        buttonBar: ButtonBar(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: FavoriteIcon(
                widget.club.code,
                FavoriteType.Club,
                _favorite,
                padding: EdgeInsets.zero,
                reloadFavoriteWhenUpdate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
