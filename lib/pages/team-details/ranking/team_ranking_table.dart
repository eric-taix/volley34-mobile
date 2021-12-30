import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';
import 'package:v34/repositories/repository.dart';

class TeamRankingTable extends StatefulWidget {
  final Team? team;
  final RankingSynthesis ranking;
  late final RankingTeamSynthesis? _teamRank;
  late final int? _teamMatches;
  late final String? highlightTeamName;
  final bool showDetailed;

  TeamRankingTable({Key? key, this.team, required this.ranking, this.highlightTeamName, this.showDetailed = false})
      : super(key: key) {
    _teamRank = ranking.ranks?.firstWhereOrNull((rank) => rank.teamCode == team?.code);
    if (_teamRank != null)
      _teamMatches = (_teamRank?.wonMatches ?? 0) + (_teamRank?.lostMatches ?? 0);
    else
      _teamMatches = null;
  }

  @override
  State<TeamRankingTable> createState() => _TeamRankingTableState();
}

class _TeamRankingTableState extends State<TeamRankingTable> {
  late Repository _repository;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showDetailed) _buildHeader(Theme.of(context).textTheme.bodyText1),
        ...widget.ranking.ranks!.reversed
            .toList()
            .asMap()
            .map(
              (index, rankingSynthesis) {
                TextStyle? lineStyle = widget.team != null
                    ? (rankingSynthesis.teamCode == widget.team?.code
                        ? Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)
                        : Theme.of(context).textTheme.bodyText1)
                    : (widget.highlightTeamName != null && widget.highlightTeamName!.isNotEmpty
                        ? (rankingSynthesis.name!.toLowerCase().contains(widget.highlightTeamName!.toLowerCase())
                            ? Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)
                            : Theme.of(context).textTheme.bodyText1!)
                        : Theme.of(context).textTheme.bodyText2!);
                return MapEntry(
                  index,
                  InkWell(
                    onTap: rankingSynthesis.teamCode != widget.team?.code && rankingSynthesis.teamCode != null
                        ? () => _goToTeamDetails(context, rankingSynthesis.teamCode!)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: _buildRow(rankingSynthesis, index, lineStyle),
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
            width: 60,
            child: Text(
              "Totaux",
              style: lineStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
            width: 60,
            child: Text(
              "Joués",
              style: lineStyle,
              textAlign: TextAlign.center,
            )),
        if (widget.showDetailed)
          SizedBox(
              width: 60,
              child: Text(
                "Gagnés",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: 60,
              child: Text(
                "Perdus",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: 60,
              child: Text(
                "Forfaits",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: 60,
              child: Text(
                "D. Sets",
                style: lineStyle,
                textAlign: TextAlign.center,
              )),
        if (widget.showDetailed)
          SizedBox(
              width: 60,
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
    double width = widget.showDetailed ? 60 : 38;
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
                      .bodyText1!
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
            width: 60,
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
          width: 20,
          child: rankingSynthesis.teamCode != widget.team?.code
              ? Icon(Icons.arrow_forward_ios_outlined, size: 14, color: lineStyle.color)
              : SizedBox(),
        )
      ],
    );
  }

  _goToTeamDetails(BuildContext context, String teamCode) {
    Future.wait([_repository.loadTeam(teamCode), _repository.loadTeamClub(teamCode)]).then((results) {
      RouterFacade.push(
          context: context, builder: (_) => TeamDetailPage(team: results[0] as Team, club: results[1] as Club));
    });
  }
}
