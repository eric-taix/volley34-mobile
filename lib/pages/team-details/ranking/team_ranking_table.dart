import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';

class TeamRankingTable extends StatefulWidget {
  final Team? team;
  final RankingSynthesis ranking;
  late final RankingTeamSynthesis? _teamRank;
  late final int? _teamMatches;
  late final List<String>? highlightTeamNames;
  final bool showDetailed;
  final VoidCallback? onPushPage;
  final VoidCallback? onPopPage;

  TeamRankingTable({
    Key? key,
    this.team,
    required this.ranking,
    this.highlightTeamNames,
    this.showDetailed = false,
    this.onPushPage,
    this.onPopPage,
  }) : super(key: key) {
    _teamRank = ranking.ranks?.firstWhereOrNull((rank) => rank.teamCode == team?.code);
    if (_teamRank != null)
      _teamMatches = (_teamRank.wonMatches ?? 0) + (_teamRank.lostMatches ?? 0);
    else
      _teamMatches = null;
  }

  @override
  State<TeamRankingTable> createState() => _TeamRankingTableState();
}

class _TeamRankingTableState extends State<TeamRankingTable> {
  double extraColumnWidth = 65;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showDetailed) _buildHeader(Theme.of(context).textTheme.bodyLarge),
        ...widget.ranking.ranks!.reversed
            .toList()
            .asMap()
            .map(
              (index, rankingSynthesis) {
                TextStyle? lineStyle = widget.team != null
                    ? (rankingSynthesis.teamCode == widget.team?.code
                        ? Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)
                        : Theme.of(context).textTheme.bodyLarge)
                    : (widget.highlightTeamNames != null && widget.highlightTeamNames!.isNotEmpty
                        ? (widget.highlightTeamNames!.fold(
                                true,
                                (bool previousValue, teamName) =>
                                    rankingSynthesis.name!.toLowerCase().contains(teamName.toLowerCase()) &&
                                    previousValue)
                            ? Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)
                            : Theme.of(context).textTheme.bodyLarge!)
                        : Theme.of(context).textTheme.bodyMedium!);
                return MapEntry(
                  index,
                  Card(
                    clipBehavior: Clip.hardEdge,
                    color: rankingSynthesis.teamCode != widget.team?.code && rankingSynthesis.teamCode != null
                        ? null
                        : Theme.of(context).canvasColor,
                    margin: EdgeInsets.only(top: 2, bottom: 2, right: 18),
                    child: InkWell(
                      onTap: rankingSynthesis.teamCode != widget.team?.code && rankingSynthesis.teamCode != null
                          ? () => _goToTeamDetails(context, rankingSynthesis.teamCode!, widget.ranking.competitionCode,
                              rankingSynthesis.name!)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: _buildRow(rankingSynthesis, index, lineStyle),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
            .values
            .toList()
      ],
    );
  }

  _buildHeader(TextStyle? lineStyle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 20,
            height: 20,
          ),
        ),
        Expanded(
          flex: 100,
          child: SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SizedBox(
            width: extraColumnWidth,
            child: Text(
              "Totaux",
              style: lineStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
            width: extraColumnWidth,
            child: Text(
              widget.team != null ? "D. Matchs" : "Joués",
              style: lineStyle,
              textAlign: TextAlign.center,
            )),
        if (widget.showDetailed)
          SizedBox(
              width: extraColumnWidth,
              child: Text(
                "Gagnés",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: extraColumnWidth,
              child: Text(
                "Perdus",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: extraColumnWidth,
              child: Text(
                "Forfaits",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: extraColumnWidth,
              child: Text(
                "D. Sets",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: extraColumnWidth,
              child: Text(
                "D. Points",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _buildRow(RankingTeamSynthesis rankingSynthesis, int index, TextStyle? lineStyle) {
    double width = widget.showDetailed ? extraColumnWidth : 48;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 20,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: lineStyle!.color,
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 100,
          child: Text(
            rankingSynthesis.name!,
            overflow: TextOverflow.fade,
            softWrap: false,
            maxLines: 1,
            style: lineStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SizedBox(
            width: width,
            child: Text(
              "${rankingSynthesis.totalPoints} pts",
              style: lineStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: Builder(
            builder: (context) {
              int totalMatches = (rankingSynthesis.wonMatches ?? 0) + (rankingSynthesis.lostMatches ?? 0);
              return totalMatches != widget._teamMatches
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget._teamMatches != null
                              ? "${totalMatches > widget._teamMatches! ? "+" : ""}${totalMatches - widget._teamMatches!}"
                              : "$totalMatches",
                          style: lineStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: SvgPicture.asset(
                            "assets/volleyball-filled.svg",
                            width: 16,
                            color: lineStyle.color,
                          ),
                        )
                      ],
                    )
                  : SizedBox();
            },
          ),
        ),
        if (widget.showDetailed)
          SizedBox(
              width: width,
              child: Text(
                "${rankingSynthesis.wonMatches}",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: width,
              child: Text("${rankingSynthesis.lostMatches}", style: lineStyle, textAlign: TextAlign.center)),
        if (widget.showDetailed)
          SizedBox(
              width: width,
              child: Text("${rankingSynthesis.forfeitMatches}", style: lineStyle, textAlign: TextAlign.center)),
        if (widget.showDetailed)
          SizedBox(
              width: width, child: Text("${rankingSynthesis.setsDiff}", style: lineStyle, textAlign: TextAlign.center)),
        if (widget.showDetailed)
          SizedBox(
              width: width,
              child: Text("${rankingSynthesis.pointsDiff}", style: lineStyle, textAlign: TextAlign.center)),
        SizedBox(
          width: 0,
          child: rankingSynthesis.teamCode != widget.team?.code
              ? Icon(Icons.arrow_forward_ios_outlined, size: 14, color: lineStyle.color)
              : SizedBox(),
        )
      ],
    );
  }

  _goToTeamDetails(BuildContext context, String teamCode, String? competitionCode, String teamName) {
    if (widget.onPushPage != null) widget.onPushPage!();
    RouterFacade.push(
        context: context,
        builder: (_) => TeamDetailPage(
              teamCode: teamCode,
              teamName: teamName,
              openedPage: competitionCode != null ? OpenedPage.COMPETITION : null,
              openedCompetitionCode: competitionCode != null ? competitionCode : null,
            )).then((_) {
      if (widget.onPopPage != null) widget.onPopPage!();
    });
  }
}
