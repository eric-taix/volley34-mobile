import 'package:flutter/material.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/results/team_results.dart';
import 'package:v34/pages/team-details/ranking/team_ranking.dart';

class TeamDetailPage extends StatelessWidget {
  final Team team;
  final List<ClassificationSynthesis> classifications;

  const TeamDetailPage({Key key, @required this.team, @required this.classifications}) : super(key: key);

  List<TextTab> _getTabs() {
    List<TextTab> tabs = classifications.map((classification) {
      return TextTab(classification.label, TeamRanking(team: team, classification: classification));
    }).toList();
    tabs.add(TextTab("Résultats", TeamResults(team: team)));
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWithImage(
      team.code,
      "hero-logo-${team.code}",
      subTitle: team.name,
      logoUrl: team.clubLogoUrl,
      tabs: _getTabs(),
      favorite: Favorite(
        team.favorite,
        team.code,
        FavoriteType.Team,
      ),
    );
  }
}
