import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:v34/models/gymnasium.dart';
import 'package:v34/utils/launch.dart';

class GymnasiumCard extends StatelessWidget {
  final Gymnasium gymnasium;

  GymnasiumCard({@required this.gymnasium});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Card(
        color: Theme.of(context).appBarTheme.color,
        margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Text(gymnasium.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline1),
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
                          if (gymnasium.phone != null && gymnasium.phone.isNotEmpty) Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                            child: OutlineButton.icon(
                              icon: Icon(Icons.phone, color: Theme.of(context).accentColor, size: 18,),
                              onPressed: () => launchURL("tel:${gymnasium.phone}"),
                              label: Text("Appeler"),
                              highlightedBorderColor: Theme.of(context).textTheme.bodyText1.color,
                              borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
                            ),
                          ),
                          if (gymnasium.longitude != null && gymnasium.latitude != null) Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                            child: OutlineButton.icon(
                              icon: Icon(Icons.directions, color: Theme.of(context).accentColor, size: 18,),
                              onPressed: () => _launchRoute(context, gymnasium),
                              label: Text("Itinéraire"),
                              highlightedBorderColor: Theme.of(context).textTheme.bodyText1.color,
                              borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
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

  void _launchRoute(BuildContext context, Gymnasium gymnasium, {bool route = true}) async {
    try {
      final coordinates = mapLauncher.Coords(gymnasium.latitude, gymnasium.longitude);
      final title = gymnasium.name;
      final availableMaps = await mapLauncher.MapLauncher.installedMaps;

      if (availableMaps.length == 1) {
        if (route) {
          availableMaps.first.showDirections(
              destination: coordinates,
              destinationTitle: title
          );
        } else {
          availableMaps.first.showMarker(
              coords: coordinates,
              title: title
          );
        }
      } else {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      for (var map in availableMaps)
                        ListTile(
                          onTap: () {
                            if (route) {
                              map.showDirections(
                                  destination: coordinates,
                                  destinationTitle: title
                              );
                            } else {
                              map.showMarker(
                                  coords: coordinates,
                                  title: title
                              );
                            }
                          },
                          title: Text(map.mapName, style: Theme.of(context).textTheme.bodyText1.apply(fontSizeDelta: 1.5)),
                          leading: Image(
                            image: map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
