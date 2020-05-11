import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/club.dart';

class ClubInformations extends StatelessWidget {
  final Club club;

  ClubInformations(this.club);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Paragraph(
          title: "Contact",
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 10.0),
            child: Card(
                child: Column(
                    children: [
                      ListTile(title: Text("Contact")),
                      ListTile(leading: Icon(Icons.person), title: Text(club.contact)),
                    ]
                )
            ),
          ),
          topPadding: 6,
        ),
      ],
    );
  }
}
