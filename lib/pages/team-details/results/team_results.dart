import 'package:flutter/cupertino.dart';
import 'package:v34/models/team.dart';

class TeamResults extends StatefulWidget {
  final Team team;

  const TeamResults({Key key, @required this.team}) : super(key: key);

  @override
  _TeamResultsState createState() => _TeamResultsState();

}

class _TeamResultsState extends State<TeamResults> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([]),
    );
  }

}