

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';

class ClubCard extends StatelessWidget {

  final Club club;
  final int index;

  ClubCard(this.club, this.index);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: double.infinity),
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Card(
            child: InkWell(
              onTap: () => print("Tapped"),
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0, right: 8.0, bottom: 12.0, left: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        club.shortName,
                        style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(club.name, style: Theme.of(context).textTheme.body1.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      RoundedNetworkImage(40, club.logoUrl),
    ]);
  }
}