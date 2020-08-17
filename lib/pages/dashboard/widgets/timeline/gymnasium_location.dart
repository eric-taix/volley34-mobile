import 'package:add_2_calendar/add_2_calendar.dart' as addToCalendar;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:v34/commons/loading.dart';
import 'package:v34/models/event.dart';
import 'package:v34/pages/dashboard/blocs/gymnasium_bloc.dart';
import 'package:v34/utils/extensions.dart';

class GymnasiumLocation extends StatefulWidget {
  final Event event;

  const GymnasiumLocation({Key key, @required this.event}) : super(key: key);

  @override
  GymnasiumLocationState createState() => GymnasiumLocationState();
}

class GymnasiumLocationState extends State<GymnasiumLocation> {
  GymnasiumBloc _gymnasiumBloc;

  @override
  void initState() {
    super.initState();
    _gymnasiumBloc = GymnasiumBloc(RepositoryProvider.of(context), GymnasiumUninitializedState());
    _gymnasiumBloc.add(LoadGymnasiumEvent(gymnasiumCode: widget.event.gymnasiumCode));
  }

  void _addEventToCalendar() async {
    final addToCalendar.Event event = addToCalendar.Event(
      title: widget.event.name,
      location: widget.event.place,
      startDate: widget.event.date,
      endDate: widget.event.date.add(Duration(hours: 2))
    );
    await addToCalendar.Add2Calendar.addEvent2Cal(event);
  }

  void _launchMap(GymnasiumLoadedState state, bool route) async {
    try {
      final coordinates = mapLauncher.Coords(state.gymnasium.latitude, state.gymnasium.longitude);
      final title = state.gymnasium.name;
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

  Widget _buildGymnasiumLocationLoaded(GymnasiumLoadedState state) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8.0),
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          height: 250,
          child: GestureDetector(
            onTap: () => _launchMap(state, false),
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(state.gymnasium.latitude, state.gymnasium.longitude),
                zoom: 13.0,
                interactive: false,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: LatLng(state.gymnasium.latitude, state.gymnasium.longitude),
                      builder: (ctx) => Container(child: Image(image: AssetImage('assets/gymnasium_marker.png'))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 8.0,
          children: [
            FlatButton.icon(
              onPressed: () => _launchMap(state, true),
              icon: Icon(Icons.directions),
              label: Text("Itinéraire"),
              color: Theme.of(context).cardTheme.titleBackgroundColor(context).tiny(10),
            ),
            FlatButton.icon(
              onPressed: () => _addEventToCalendar(),
              icon: Icon(Icons.calendar_today),
              label: Text("Ajouter à l'agenda"),
              color: Theme.of(context).cardTheme.titleBackgroundColor(context),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _gymnasiumBloc,
      builder: (context, state) {
        if (state is GymnasiumLoadedState) return _buildGymnasiumLocationLoaded(state);
        else if (state is GymnasiumLoadingState) return Loading();
        else return Container();
      },
    );
  }

}