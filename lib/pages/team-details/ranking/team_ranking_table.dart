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
  final Team team;
  final RankingSynthesis ranking;
  late final RankingTeamSynthesis _teamRank;
  late final int _teamMatches;

  TeamRankingTable({Key? key, required this.team, required this.ranking}) : super(key: key) {
    _teamRank = ranking.ranks?.firstWhere((rank) => rank.teamCode == team.code) ?? RankingTeamSynthesis.empty();
    _teamMatches = (_teamRank.wonMatches ?? 0) + (_teamRank.lostMatches ?? 0);
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
        if (widget.ranking.ranks != null)
          ...widget.ranking.ranks!.reversed
              .toList()
              .asMap()
              .map(
                (index, rankingSynthesis) {
                  return MapEntry(
                    index,
                    InkWell(
                      onTap: rankingSynthesis.teamCode != widget.team.code && rankingSynthesis.teamCode != null
                          ? () => _goToTeamDetails(context, rankingSynthesis.teamCode!)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        color: rankingSynthesis.teamCode == widget.team.code
                                            ? Theme.of(context).textTheme.bodyText2!.color
                                            : Theme.of(context).textTheme.bodyText1!.color),
                                    child: Center(
                                      child: Text(
                                        "${index + 1}",
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                            color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
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
                                  style: rankingSynthesis.teamCode == widget.team.code
                                      ? Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)
                                      : Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: SizedBox(
                                  width: 60,
                                  child: Text(
                                    "${rankingSynthesis.wonSets} pts",
                                    style: rankingSynthesis.teamCode == widget.team.code
                                        ? Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)
                                        : Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 38,
                                child: Builder(
                                  builder: (context) {
                                    int totalMatches =
                                        (rankingSynthesis.wonMatches ?? 0) + (rankingSynthesis.lostMatches ?? 0);
                                    return totalMatches != widget._teamMatches
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${totalMatches > widget._teamMatches ? "+" : ""}${totalMatches - widget._teamMatches}",
                                                style: rankingSynthesis.teamCode == widget.team.code
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(fontWeight: FontWeight.bold)
                                                    : Theme.of(context).textTheme.bodyText1,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 4.0),
                                                child: SvgPicture.asset(
                                                  "assets/volleyball-filled.svg",
                                                  width: 16,
                                                  color: rankingSynthesis.teamCode == widget.team.code
                                                      ? Theme.of(context).textTheme.bodyText2!.color
                                                      : Theme.of(context).textTheme.bodyText1!.color,
                                                ),
                                              )
                                            ],
                                          )
                                        : SizedBox();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                                child: rankingSynthesis.teamCode != widget.team.code
                                    ? Icon(Icons.arrow_forward_ios_outlined,
                                        size: 14, color: Theme.of(context).textTheme.bodyText1!.color)
                                    : SizedBox(),
                              )
                            ],
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

  _goToTeamDetails(BuildContext context, String teamCode) {
    Future.wait([_repository.loadTeam(teamCode), _repository.loadTeamClub(teamCode)]).then((results) {
      RouterFacade.push(
          context: context, builder: (_) => TeamDetailPage(team: results[0] as Team, club: results[1] as Club));
    });
  }
}
