import 'package:flutter/material.dart';
import 'package:v34/pages/scorer/action.model.dart';

class ScorerAction extends StatelessWidget {
  final ScoreAction action;
  final bool enabled;

  const ScorerAction({Key? key, required this.action, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color actionColor = (action.attitude == ScoreAttitude.positive ? Colors.green : Colors.red);
    return Expanded(
        child: Container(
            child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(6),
      color: enabled ? actionColor : actionColor.withValues(alpha: 0.2),
      child: InkWell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              action.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: enabled
                        ? Theme.of(context).textTheme.bodyMedium!.color
                        : Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.3),
                  ),
            ),
          ),
        ),
        onTap: enabled ? () => null : null,
      ),
    )));
  }
}
