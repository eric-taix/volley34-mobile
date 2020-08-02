import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/fluid_expansion_card/fluid_expansion_card.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';

class ResultCard extends StatelessWidget {
  final Team team;
  final MatchResult result;

  static final List<IconData> _setIcons = [Icons.looks_one, Icons.looks_two, Icons.looks_3, Icons.looks_4, Icons.looks_5];

  const ResultCard({Key key, @required this.team, @required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int countSet = result.sets.fold(0, (count, set) => set.visitorpoint != null && set.hostPoint != null ? count + 1 : count);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
      child: FluidExpansionCard(
        topCardHeight: 100,
        topCardWidget: _buildResult(context),
        bottomCardHeight: (countSet + 1) * 40.0,
        bottomCardWidget: _buildResultDetails(context),
        borderRadius: 12,
        width: MediaQuery
            .of(context)
            .size
            .width - 40,
        color: Theme
            .of(context)
            .cardTheme
            .color,
      ),
    );
  }

  Widget _buildResultDetails(BuildContext context) {
    List<MatchSet> sets = result.sets.where((set) => set.hostPoint != null && set.visitorpoint != null).toList();
    MatchSet totalMatchSet = sets.fold(
      MatchSet(0, 0),
          (total, matchSet) => MatchSet(matchSet.hostPoint + total.hostPoint, matchSet.visitorpoint + total.visitorpoint),
    );
    return Column(
        children: [
          ...sets.asMap().map((index, set) =>
              MapEntry(index, Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Set n°",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1,
                        ),
                        Icon(_setIcons[index], color: Theme
                            .of(context)
                            .accentColor),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Center(child: _buildPoints(context, set))
                  )
                ],
              ))).values.toList(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Total",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,
                          ),
                        ]
                    )
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPoints(context, totalMatchSet, colored: false)
                    ]
                  )
                )
              ]
          )
        ]
    );
  }

  Widget _buildResult(BuildContext context) {
    int diffSets = result.totalSetsHost - result.totalSetsVisitor;
    DateFormat _dateFormat = DateFormat('EEE dd/M', "FR");

    Color scoreColor;
    String resultString;

    if ((diffSets > 0) || (diffSets == 0 && result.totalPointsHost > result.totalPointsVisitor)) {
      scoreColor = team.code == result.hostTeamCode ? Colors.green : Colors.red;
      resultString = "gagne contre";
    } else {
      scoreColor = team.code == result.hostTeamCode ? Colors.red : Colors.green;
      resultString = "perd contre";
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Container(
          decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme
              .of(context)
              .accentColor, width: 0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: "${result.totalSetsHost}",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: (team.code == result.hostTeamCode) ? scoreColor : Theme
                              .of(context)
                              .textTheme
                              .bodyText2
                              .color,
                        ),
                        children: [
                          TextSpan(
                              text: " - ",
                              style: TextStyle(
                                fontSize: 28.0,
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    .color,
                              )),
                          TextSpan(
                              text: "${result.totalSetsVisitor}",
                              style: TextStyle(
                                fontSize: 28.0,
                                color: (team.code == result.visitorTeamCode) ? scoreColor : Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText2
                                    .color,
                              )),
                        ]),
                  ),
                ),
              ),
              Text("${_dateFormat.format(result.matchDate)}", style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1),
            ]),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${result.hostName}",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  resultString,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                ),
              ),
              Text(
                "${result.visitorName}",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildPoints(BuildContext context, MatchSet matchSet, {bool colored = true}) {
    double fontSize = 20.0;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 18, right: 18),
      child: RichText(
        text: TextSpan(
            text: "${matchSet.hostPoint}",
            style: TextStyle(
              fontSize: fontSize,
              color: (team.code == result.hostTeamCode && colored)
                  ? (matchSet.hostPoint > matchSet.visitorpoint ? Colors.green : Colors.red)
                  : Theme
                  .of(context)
                  .textTheme
                  .bodyText2
                  .color,
            ),
            children: [
              TextSpan(
                  text: " - ",
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .textTheme
                        .bodyText1
                        .color,
                  )),
              TextSpan(
                  text: "${matchSet.visitorpoint}",
                  style: TextStyle(
                    fontSize: fontSize,
                    color: (team.code == result.visitorTeamCode && colored)
                        ? (matchSet.visitorpoint > matchSet.hostPoint ? Colors.green : Colors.red)
                        : Theme
                        .of(context)
                        .textTheme
                        .bodyText2
                        .color,
                  )),
            ]),
      ),
    );
  }
}
