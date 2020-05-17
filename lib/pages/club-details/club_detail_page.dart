import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/no_data.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/models/club.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/repositories/repository.dart';

import 'informations/club_informations.dart';
import 'statistics/club_statistics.dart';

class ClubDetailPage extends StatefulWidget {
  final Club club;

  ClubDetailPage(this.club);

  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {

  Repository _repository;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _repository.loadFavoriteClubs().then((favorites) {
      setState(() {
        widget.club.favorite = favorites.contains(widget.club.code);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWithImage(
      widget.club.shortName,
      "hero-logo-${widget.club.code}",
      subTitle: widget.club.name,
      logoUrl: widget.club.logoUrl,
      tabs: [
        TextTab("Informations", ClubInformations(widget.club)),
        TextTab("Statistiques", ClubStatistics(widget.club)),
        TextTab("Equipes", NoData("soon...")),
      ],
      favorite: Favorite(
        widget.club.favorite,
        widget.club.code,
        FavoriteType.Club,
      ),
    );
  }
}
