import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/rounded_outlined_button.dart';
import 'package:v34/models/gymnasium.dart';
import 'package:v34/utils/launch.dart';

class GymnasiumCard extends StatelessWidget {
  final Gymnasium gymnasium;

  GymnasiumCard({required this.gymnasium});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Card(
          //color: Theme.of(context).appBarTheme.backgroundColor,
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Text(
                    gymnasium.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                )),
                Text(
                  "${gymnasium.address}",
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  "${gymnasium.postalCode} ${gymnasium.town}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (gymnasium.longitude != null && gymnasium.latitude != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                              child: ElevatedButton.icon(
                                onPressed: () => launchRoute(context, gymnasium),
                                icon: Icon(Icons.directions),
                                label: Text("Itinéraire"),
                              ),
                            ),
                          if (gymnasium.phone != null && gymnasium.phone!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                              child: RoundedOutlinedButton(
                                leadingIcon: Icons.phone,
                                onPressed: () => launchURL("tel:${gymnasium.phone}"),
                                child: Text("Appeler"),
                              ),
                            ),
                        ],
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
