import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/informations/club_contact.dart';
import 'package:v34/pages/club-details/informations/club_gymnasiums_slots.dart';
import 'package:v34/utils/analytics.dart';

class ClubInformations extends StatefulWidget {
  final Club? club;

  ClubInformations(this.club);

  @override
  State<ClubInformations> createState() => _ClubInformationsState();
}

class _ClubInformationsState extends State<ClubInformations> with RouteAwareAnalytics {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ClubContact(club: widget.club),
        ClubGymnasiumsSlots(clubCode: widget.club!.code),
      ]),
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.club_informations;
}
