import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/force_teams.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/force.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';

class MatchInfo extends StatelessWidget {
  static const double OUTER_PADDING = 22;
  static const double INNER_PADDING = 3;
  static const double ICON_SIZE = 20;

  final Team? hostTeam;
  final Force? hostForce;
  final Team? visitorTeam;
  final Force? visitorForce;
  final Force? globalForce;
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
    this.hostForce,
    this.visitorForce,
    this.globalForce,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 18, left: 28, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(context),
          _buildOpponent(context, hostTeam, hostClub, showTeamLink),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: ForceTeams(
              hostForce: hostForce,
              visitorForce: visitorForce,
              globalForce: globalForce,
              showDivider: true,
              backgroundColor: Theme.of(context).primaryColor,
            ),
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
          child: hostTeam != null && hostClub != null
              ? Hero(
                  tag: "hero-logo-${hostTeam!.code}",
                  child: RoundedNetworkImage(40, hostClub!.logoUrl ?? ""),
                )
              : SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: visitorTeam != null && visitorClub != null
              ? Hero(
                  tag: "hero-logo-${visitorTeam?.code}",
                  child: RoundedNetworkImage(40, visitorClub?.logoUrl ?? ""),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  Widget _buildOpponent(BuildContext context, Team? team, Club? club, bool linkToTeam) {
    return ListTile(
      onTap: linkToTeam && team != null && club != null
          ? () => RouterFacade.push(context: context, builder: (_) => TeamDetailPage(team: team, club: club))
          : null,
      title: team != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    team.name ?? "",
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
            )
          : Loading(loaderType: LoaderType.THREE_BOUNCE),
    );
  }
}
