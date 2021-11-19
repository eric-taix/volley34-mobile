import 'package:flutter/material.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';
import 'package:v34/pages/dashboard/widgets/fav_club_card.dart';

import '../../../commons/router.dart';

class DashboardClub extends StatelessWidget {
  final double cardHeight = 250;
  final Club club;
  const DashboardClub({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: cardHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 0),
            child: FavoriteClubCard(
              club,
              () => RouterFacade.push(context: context, builder: (_) => ClubDetailPage(club)),
            ),
          ),
        ),
      ],
    );
  }
}
