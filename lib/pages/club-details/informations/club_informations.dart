import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/informations/club_contact.dart';
import 'package:v34/pages/club-details/informations/club_gymnasiums_slots.dart';

class ClubInformations extends StatelessWidget {
  final Club club;

  ClubInformations(this.club);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClubContact(club: club),
        ClubGymnasiumsSlots(clubCode: club.code),
      ],
    );
  }
}


