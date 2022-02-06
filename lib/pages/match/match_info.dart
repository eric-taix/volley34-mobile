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
  final Team? visitorTeam;
  final Forces? forces;
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
    this.forces,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: _buildOpponent(context, hostTeam, hostClub, showTeamLink),
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: ForceTeams(
              forces: forces,
              hostCode: hostTeam?.code ?? "",
              visitorCode: visitorTeam?.code ?? "",
              showDivider: true,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: _buildOpponent(context, visitorTeam, visitorClub, showTeamLink),
          ),
          if (showMatchDate && date != null)
            Text("${dateFormat.format(date!)}", style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }

  Widget _buildOpponent(BuildContext context, Team? team, Club? club, bool linkToTeam) {
    return team != null
        ? Container(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 28),
                  color: linkToTeam ? null : Theme.of(context).canvasColor,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: linkToTeam && club != null
                        ? () => RouterFacade.push(
                            context: context,
                            builder: (_) => TeamDetailPage(teamCode: team.code!, teamName: team.name!, club: club))
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 38, top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              (team.name ?? ""),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: -8,
                    left: 8,
                    child: (club != null)
                        ? Hero(
                            tag: "hero-logo-${team.code}",
                            child: RoundedNetworkImage(40, club.logoUrl ?? ""),
                          )
                        : SizedBox())
              ],
            ),
          )
        : Loading(loaderType: LoaderType.THREE_BOUNCE);
  }
}
