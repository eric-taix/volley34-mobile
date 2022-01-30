import 'package:flutter/material.dart';
import 'package:v34/pages/scorer/action.model.dart';
import 'package:v34/pages/scorer/score.model.dart';
import 'package:v34/pages/scorer/scorer_action.dart';

class ScorerActions extends StatefulWidget {
  final Score score;

  const ScorerActions({Key? key, required this.score}) : super(key: key);

  @override
  State<ScorerActions> createState() => _ScorerActionsState();
}

class _ScorerActionsState extends State<ScorerActions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScorerAction(action: SERVE_POINT, enabled: true),
                ScorerAction(action: SERVE_ERROR, enabled: true),
                ScorerAction(action: RECEPTION_ERROR, enabled: false),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScorerAction(action: ATTACK_POINT, enabled: true),
                ScorerAction(action: ATTACK_BLOCKED, enabled: true),
                ScorerAction(action: ATTACK_ERROR, enabled: true),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScorerAction(action: BLOCK_POINT, enabled: true),
                ScorerAction(action: GENERIC_ERROR, enabled: true),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScorerAction(action: OPPONENT_ERROR, enabled: true),
                ScorerAction(action: OPPONENT_POINT, enabled: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
