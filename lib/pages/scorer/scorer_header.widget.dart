import 'package:flutter/material.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/scorer/score.model.dart';

class ScorerHeader extends StatelessWidget {
  final Team team1;
  final Team team2;
  final Score score;

  const ScorerHeader({Key? key, required this.team1, required this.team2, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(team1.name!, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText2),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:
                          Text(team2.name!, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${score.hostSets}", style: Theme.of(context).textTheme.bodyText2),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("${score.visitorSets}", style: Theme.of(context).textTheme.bodyText2),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("${score.hostCurrentPoint}",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("${score.visitorCurrentPoint}",
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
