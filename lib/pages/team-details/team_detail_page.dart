import 'package:flutter/cupertino.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/results/team_results.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;

  const TeamDetailPage({Key key, @required this.team}) : super(key: key);

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {

  @override
  Widget build(BuildContext context) {
    return AppBarWithImage(
      widget.team.code,
      "hero-logo-${widget.team.code}",
      subTitle: widget.team.name,
      logoUrl: widget.team.clubLogoUrl,
      tabs: [
        TextTab("Résultats", TeamResults(team: widget.team)),
      ],
      favorite: Favorite(
        widget.team.favorite,
        widget.team.code,
        FavoriteType.Team,
      ),
    );
  }
}
