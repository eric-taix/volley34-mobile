import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:v34/commons/loading.dart';
import 'package:v34/models/event.dart';
import 'package:v34/pages/dashboard/blocs/gymnasium_bloc.dart';

class EventPlace extends StatefulWidget {
  final Event event;

  const EventPlace({Key key, @required this.event}) : super(key: key);

  @override
  _EventPlaceState createState() => _EventPlaceState();
}

class _EventPlaceState extends State<EventPlace> with SingleTickerProviderStateMixin {
  bool isMapOpened = false;
  GymnasiumBloc _gymnasiumBloc;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.event.type == EventType.Match) {
      _gymnasiumBloc = GymnasiumBloc(RepositoryProvider.of(context), GymnasiumUninitializedState());
      _gymnasiumBloc.add(LoadGymnasiumEvent(gymnasiumCode: widget.event.gymnasiumCode));
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _toggleMap() async {
    if (isMapOpened) await _controller.reverse();
    else await _controller.forward();
    setState(() => isMapOpened = !isMapOpened);
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
          padding: EdgeInsets.symmetric(vertical: 8.0),
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
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: OutlineButton.icon(
            onPressed: () => _launchMap(state, true),
            icon: Icon(Icons.directions),
            label: Text("Itinéraire"),
            borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Widget map) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isMapOpened) OutlineButton.icon(
            onPressed: () => _toggleMap(),
            icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).accentColor.withOpacity(0.5)),
            label: Text("Ouvrir la carte"),
            borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
          ) else OutlineButton.icon(
            onPressed: () => _toggleMap(),
            icon: Icon(Icons.keyboard_arrow_up, color: Theme.of(context).accentColor.withOpacity(0.5)),
            label: Text("Fermer la carte"),
            borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1.color, width: 0.5),
          ),
          SizeTransition(axis: Axis.vertical, sizeFactor: _controller, child: map)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.event.type == EventType.Match) {
      return BlocBuilder(
        cubit: _gymnasiumBloc,
        builder: (context, state) {
          if (state is GymnasiumLoadedState) {
            return _buildContent(context, _buildGymnasiumLocationLoaded(state));
          } else {
            return Loading();
          }
        },
      );
    } else return Container();
  }
}