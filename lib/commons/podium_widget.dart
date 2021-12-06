import 'package:flutter/material.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/podium.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/utils/competition_text.dart';

class PodiumWidget extends StatelessWidget {
  final String? title;
  final RankingSynthesis classification;
  final bool currentlyDisplayed;
  final String? highlightedTeamCode;
  final bool showTrailing;

  const PodiumWidget({
    Key? key,
    this.title,
    required this.classification,
    required this.currentlyDisplayed,
    required this.highlightedTeamCode,
    this.showTrailing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var placeValues = classification.ranks?.map((teamClassification) {
          return PlaceValue(teamClassification.teamCode, teamClassification.totalPoints!.toDouble());
        }).toList() ??
        <PlaceValue>[];
    var highlightedIndex = placeValues.indexWhere((placeValue) => placeValue.id == highlightedTeamCode);
    return Podium(
      placeValues,
      active: currentlyDisplayed,
      title: title ?? classification.label ?? "",
      highlightedIndex: highlightedIndex,
      promoted: classification.promoted,
      relegated: classification.relegated,
      trailing: showTrailing
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 20, maxWidth: 45),
                    child: CompetitionBadge(
                      showSubTitle: false,
                      competitionCode: classification.competitionCode,
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      "${getClassificationCategory(classification.division)}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }
}
