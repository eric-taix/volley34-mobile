import 'package:flutter/material.dart';
import 'package:v34/commons/podium.dart';
import 'package:v34/models/classication.dart';

class PodiumWidget extends StatelessWidget {
  final String title;
  final ClassificationSynthesis classification;
  final bool currentlyDisplayed;
  final String highlightedTeamCode;

  const PodiumWidget({Key key, this.title, @required this.classification, @required this.currentlyDisplayed, @required this.highlightedTeamCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var placeValues = classification.teamsClassifications.map((teamClassification) {
      return PlaceValue(teamClassification.teamCode, teamClassification.totalPoints.toDouble());
    }).toList();
    var highlightedIndex = placeValues.indexWhere((placeValue) => placeValue.id == highlightedTeamCode);
    return Podium(
      placeValues,
      active: currentlyDisplayed,
      title: title ?? classification.label,
      highlightedIndex: highlightedIndex,
      promoted: classification.promoted,
      relegated: classification.relegated,
    );
  }

}