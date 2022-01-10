import 'package:flutter/material.dart';

class LandscapeHelper extends StatelessWidget {
  const LandscapeHelper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation != Orientation.landscape
        ? Padding(
            padding: EdgeInsets.only(top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child:
                      Icon(Icons.stay_primary_landscape_rounded, color: Theme.of(context).textTheme.bodyText1!.color!),
                ),
                Text(
                  "Tournez votre téléphone pour plus de détails",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.bodyText1!.color!),
                ),
              ],
            ))
        : SizedBox(height: 18);
  }
}
