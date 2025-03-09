import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:v34/models/gymnasium.dart';

launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}

void launchRoute(BuildContext context, Gymnasium gymnasium, {bool route = true}) async {
  try {
    final coordinates = mapLauncher.Coords(gymnasium.latitude!, gymnasium.longitude!);
    final title = gymnasium.name;
    final availableMaps = await mapLauncher.MapLauncher.installedMaps;

    if (availableMaps.length == 1) {
      if (route) {
        availableMaps.first.showDirections(destination: coordinates, destinationTitle: title);
      } else {
        availableMaps.first.showMarker(coords: coordinates, title: title!);
      }
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
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
                            map.showDirections(destination: coordinates, destinationTitle: title);
                          } else {
                            map.showMarker(coords: coordinates, title: title!);
                          }
                        },
                        title: Text(map.mapName,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)),
                        leading: SvgPicture.asset(
                          map.icon,
                          width: 50,
                          height: 50,
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
