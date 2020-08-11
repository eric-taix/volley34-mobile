import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/models/club.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/pages/club-details/teams/club_teams.dart';

import 'informations/club_informations.dart';
import 'statistics/club_statistics.dart';

class ClubDetailPage extends StatefulWidget {
  final Club club;

  ClubDetailPage(this.club);

  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWithImage(
      widget.club.shortName,
      "hero-logo-${widget.club.code}",
      subTitle: widget.club.name,
      logoUrl: widget.club.logoUrl,
      tabs: [
        TextTab("Statistiques", ClubStatistics(widget.club)),
        TextTab("Equipes", ClubTeams(widget.club)),
        TextTab("Informations", ClubInformations(widget.club)),
      ],
      favorite: Favorite(
        widget.club.favorite,
        widget.club.code,
        FavoriteType.Club,
      ),
    );
  }
}
