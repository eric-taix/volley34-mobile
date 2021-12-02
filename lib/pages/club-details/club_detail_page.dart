import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/models/club.dart';
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
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return Text("Statistiques");
          case 1:
            return Text("Equipes");
          default:
            return Text("Informations");
        }
      },
      favorite: Favorite(
        widget.club.code,
        FavoriteType.Club,
      ),
      itemCount: 3,
      pageBuilder: (context, index) {
        switch (index) {
          case 0:
            return ClubStatistics(widget.club);
          case 1:
            return ClubTeams(widget.club);
          default:
            return ClubInformations(widget.club);
        }
      },
    );
  }
}
