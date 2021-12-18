import 'package:flutter/material.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/match/match_info.dart';

class PostPoneMatch extends StatefulWidget {
  final Team hostTeam;
  final Team visitorTeam;
  final Club hostClub;
  final Club visitorClub;
  final DateTime matchDate;

  const PostPoneMatch({
    Key? key,
    required this.hostTeam,
    required this.visitorTeam,
    required this.hostClub,
    required this.visitorClub,
    required this.matchDate,
  }) : super(key: key);

  @override
  _PostPoneMatchState createState() => _PostPoneMatchState();
}

class _PostPoneMatchState extends State<PostPoneMatch> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Report d'un match"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: FocusScope(
          child: ListView(
            children: [
              MatchInfo(
                hostTeam: widget.hostTeam,
                visitorTeam: widget.visitorTeam,
                hostClub: widget.hostClub,
                visitorClub: widget.visitorClub,
                date: widget.matchDate,
                showTeamLink: false,
                showMatchDate: true,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Paragraph(title: "Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
