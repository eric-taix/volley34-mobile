import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/fluid_expansion_card/fluid_expansion_card.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/results/result_bar.dart';
import 'package:v34/repositories/repository.dart';

class ResultCard extends StatefulWidget {
  final Team team;
  final MatchResult result;

  static final List<IconData> _setIcons = [
    Icons.looks_one,
    Icons.looks_two,
    Icons.looks_3,
    Icons.looks_4,
    Icons.looks_5
  ];

  const ResultCard({Key? key, required this.team, required this.result}) : super(key: key);

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  List<Competition>? _competitions;

  @override
  void initState() {
    super.initState();
    Repository repository = RepositoryProvider.of<Repository>(context);
    repository.loadAllCompetitions().then((competitions) {
      setState(() {
        _competitions = competitions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int countSet = widget.result.sets!
        .fold(0, (count, set) => set.visitorpoint != null && set.hostPoint != null ? count + 1 : count);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
      child: FluidExpansionCard(
        topCardHeight: 120,
        topCardWidget: _buildResult(context),
        bottomCardHeight: (countSet + 1) * 41.0 + 18,
        bottomCardWidget: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: _buildResultDetails(context),
        ),
        borderRadius: 12,
        width: MediaQuery.of(context).size.width - 40,
        color: Theme.of(context).cardTheme.color,
      ),
    );
  }

  Widget _buildResultDetails(BuildContext context) {
    List<MatchSet> sets =
        widget.result.sets!.where((set) => set.hostPoint != null && set.visitorpoint != null).toList();
    MatchSet totalMatchSet = sets.fold(
      MatchSet(0, 0),
      (total, matchSet) =>
          MatchSet(matchSet.hostPoint! + total.hostPoint!, matchSet.visitorpoint! + total.visitorpoint!),
    );
    MinMax minMax = sets.fold(
        MinMax(0, 0),
        (minMax, set) => MinMax(
              set.hostPoint! - set.visitorpoint! < minMax.min ? set.hostPoint! - set.visitorpoint! : minMax.min,
              set.hostPoint! - set.visitorpoint! > minMax.max ? set.hostPoint! - set.visitorpoint! : minMax.max,
            ));
    return Column(children: [
      ...sets
          .asMap()
          .map((index, set) => MapEntry(
              index,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Set n°",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Icon(ResultCard._setIcons[index], color: Theme.of(context).textTheme.bodyText1!.color!),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: _buildPoints(
                          context,
                          set,
                          minMax,
                          widget.team.code == widget.result.hostTeamCode,
                          true,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: widget.team.code == widget.result.hostTeamCode ||
                              widget.team.code == widget.result.visitorTeamCode
                          ? ResultBar(
                              minMax: minMax,
                              diffValue: set.hostPoint! - set.visitorpoint!,
                              isHost: widget.team.code == widget.result.hostTeamCode)
                          : SizedBox(),
                    )
                  ],
                ),
              )))
          .values
          .toList(),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Expanded(
            flex: 3,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Total",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ])),
        Expanded(
          flex: 5,
          child: Center(
            child: _buildPoints(
              context,
              totalMatchSet,
              minMax,
              widget.team.code == widget.result.hostTeamCode,
              false,
              colored: false,
            ),
          ),
        ),
        Expanded(flex: 2, child: SizedBox())
      ])
    ]);
  }

  Widget _buildResult(BuildContext context) {
    int diffSets = widget.result.totalSetsHost! - widget.result.totalSetsVisitor!;
    DateFormat _dateFormat = DateFormat('EEE dd/M', "FR");

    Color scoreColor;
    String resultString;

    if ((diffSets > 0) || (diffSets == 0 && widget.result.totalPointsHost! > widget.result.totalPointsVisitor!)) {
      scoreColor = widget.team.code == widget.result.hostTeamCode
          ? Colors.green
          : (widget.team.code == widget.result.visitorTeamCode
              ? Colors.red
              : Theme.of(context).textTheme.bodyText2!.color!);
      resultString = "gagne contre";
    } else {
      scoreColor = widget.team.code == widget.result.hostTeamCode ? Colors.red : Colors.green;
      resultString = "perd contre";
    }
    Competition? competition;
    if (_competitions != null) {
      competition = _competitions!.firstWhereOrNull((competition) => competition.code == widget.result.competitionCode);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          competition != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                      width: 34,
                      child: CompetitionBadge(
                        showSubTitle: false,
                        competitionCode: widget.result.competitionCode,
                        labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        "${competition.label}",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10),
                      ),
                    )
                  ],
                )
              : SizedBox(height: 18),
          SizedBox(
            height: 70,
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color!, width: 0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: "${widget.result.totalSetsHost}",
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: (widget.team.code == widget.result.hostTeamCode)
                                    ? scoreColor
                                    : Theme.of(context).textTheme.bodyText2!.color,
                              ),
                              children: [
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      color: Theme.of(context).textTheme.bodyText1!.color,
                                    )),
                                TextSpan(
                                    text: "${widget.result.totalSetsVisitor}",
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      color: (widget.team.code == widget.result.visitorTeamCode)
                                          ? scoreColor
                                          : Theme.of(context).textTheme.bodyText2!.color,
                                    )),
                              ]),
                        ),
                      ),
                    ),
                    Text("${_dateFormat.format(widget.result.matchDate!)}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ]),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.result.hostName}",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.result.hostTeamCode == widget.team.code ? scoreColor : null),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        resultString,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Text(
                      "${widget.result.visitorName}",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.result.visitorTeamCode == widget.team.code ? scoreColor : null),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPoints(BuildContext context, MatchSet matchSet, MinMax minMax, bool isHost, bool showBar,
      {bool colored = true}) {
    double fontSize = 20.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 18, right: 18),
          child: RichText(
            text: TextSpan(
                text: "${matchSet.hostPoint}",
                style: TextStyle(
                  fontSize: fontSize,
                  color: (widget.team.code == widget.result.hostTeamCode && colored)
                      ? (matchSet.hostPoint! > matchSet.visitorpoint! ? Colors.green : Colors.red)
                      : Theme.of(context).textTheme.bodyText2!.color,
                ),
                children: [
                  TextSpan(
                      text: " - ",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      )),
                  TextSpan(
                      text: "${matchSet.visitorpoint}",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: (widget.team.code == widget.result.visitorTeamCode && colored)
                            ? (matchSet.visitorpoint! > matchSet.hostPoint! ? Colors.green : Colors.red)
                            : Theme.of(context).textTheme.bodyText2!.color,
                      )),
                ]),
          ),
        ),
      ],
    );
  }
}
