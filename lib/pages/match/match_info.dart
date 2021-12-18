import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';

class MatchInfo extends StatelessWidget {
  final Team? hostTeam;
  final Team? visitorTeam;
  final Club? hostClub;
  final Club? visitorClub;
  final DateTime? date;
  final bool showTeamLink;
  final bool showMatchDate;

  final DateFormat dateFormat = DateFormat("le EEEE dd MMMM à HH:mm", "FR");

  MatchInfo({
    Key? key,
    required this.hostTeam,
    required this.visitorTeam,
    required this.hostClub,
    required this.visitorClub,
    required this.date,
    required this.showTeamLink,
    required this.showMatchDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(context),
          _buildOpponent(context, hostTeam, hostClub, showTeamLink),
          Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text("reçoit", style: Theme.of(context).textTheme.bodyText1),
          ),
          _buildOpponent(context, visitorTeam, visitorClub, showTeamLink),
          if (showMatchDate && date != null)
            Text("${dateFormat.format(date!)}", style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Hero(
            tag: "hero-logo-${hostTeam?.code}",
            child: RoundedNetworkImage(40, hostClub?.logoUrl ?? ""),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Hero(
            tag: "hero-logo-${visitorTeam?.code}",
            child: RoundedNetworkImage(40, visitorClub?.logoUrl ?? ""),
          ),
        ),
      ],
    );
  }

  Widget _buildOpponent(BuildContext context, Team? team, Club? club, bool linkToTeam) {
    return ListTile(
      onTap: linkToTeam && team != null && club != null
          ? () => RouterFacade.push(context: context, builder: (_) => TeamDetailPage(team: team, club: club))
          : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              team?.name ?? "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          if (showTeamLink)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
            ),
        ],
      ),
    );
  }
}
