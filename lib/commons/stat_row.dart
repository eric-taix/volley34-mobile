import 'package:flutter/material.dart';

class StatRow extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;
  const StatRow({Key? key, required this.title, required this.child, this.height = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  height: height,
                  child: Center(
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
