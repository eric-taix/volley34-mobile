import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:v34/commons/loading.dart';
import 'package:v34/models/event.dart';
import 'package:v34/pages/dashboard/blocs/gymnasium_bloc.dart';
import 'package:v34/utils/extensions.dart';

class EventPlace extends StatefulWidget {
  final Event event;

  const EventPlace({Key key, @required this.event}) : super(key: key);

  @override
  _EventPlaceState createState() => _EventPlaceState();
}

class _EventPlaceState extends State<EventPlace> {
  GymnasiumBloc _gymnasiumBloc;
  String _rawMapStyle;
  String _currentMapStyle;
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.event.type == EventType.Match) {
      _gymnasiumBloc = GymnasiumBloc(
          RepositoryProvider.of(context), GymnasiumUninitializedState());
      _gymnasiumBloc
          .add(LoadGymnasiumEvent(gymnasiumCode: widget.event.gymnasiumCode));
    }
    rootBundle.loadString('assets/maps/map_style.txt').then((mapStyle) {
      _rawMapStyle = mapStyle;
      _applyMapStyle(context);
    });
  }

  @override
  void dispose() {
    if (_mapController != null) _mapController.dispose();
    super.dispose();
  }

  void _applyMapStyle(BuildContext buildContext) {
    if (_rawMapStyle != null) {
      ThemeData themeData = Theme.of(buildContext);
      _currentMapStyle = _rawMapStyle
          .replaceAll("{appBarTheme.color}",
              themeData.appBarTheme.color.toHexWithoutAlpha())
          .replaceAll(
              "{canvasColor}", themeData.canvasColor.toHexWithoutAlpha())
          .replaceAll(
              "{buttonColor}", themeData.buttonColor.toHexWithoutAlpha())
          .replaceAll("{labelColor}",
              themeData.textTheme.bodyText2.color.toHexWithoutAlpha());
      if (_mapController != null) {
        _mapController.setMapStyle(_currentMapStyle);
      }
    }
  }

  void _launchMap(GymnasiumLoadedState state, bool route) async {
    try {
      final coordinates = mapLauncher.Coords(
          state.gymnasium.latitude, state.gymnasium.longitude);
      final title = state.gymnasium.name;
      final availableMaps = await mapLauncher.MapLauncher.installedMaps;

      if (availableMaps.length == 1) {
        if (route) {
          availableMaps.first.showDirections(
              destination: coordinates, destinationTitle: title);
        } else {
          availableMaps.first.showMarker(coords: coordinates, title: title);
        }
      } else {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
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
                                  destinationTitle: title);
                            } else {
                              map.showMarker(coords: coordinates, title: title);
                            }
                          },
                          title: Text(map.mapName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .apply(fontSizeDelta: 1.5)),
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
          margin: EdgeInsets.symmetric(horizontal: 36.0),
          height: 250,
          child: GestureDetector(
            onTap: () => _launchMap(state, false),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                  markers: [
                    Marker(
                      markerId: MarkerId(state.gymnasium.gymnasiumCode),
                      position: LatLng(
                          state.gymnasium.latitude, state.gymnasium.longitude),
                    )
                  ].toSet(),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          state.gymnasium.latitude, state.gymnasium.longitude),
                      zoom: 11),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: _onMapCreated,
                  gestureRecognizers: [
                    Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    )
                  ].toSet()),
            ),
          ),
        ),
        RaisedButton.icon(
          onPressed: () => _launchMap(state, true),
          icon: Icon(Icons.directions),
          label: Text("Itinéraire"),
        ),
      ],
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller..setMapStyle(_currentMapStyle);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.event.type == EventType.Match) {
      return BlocBuilder(
        cubit: _gymnasiumBloc,
        builder: (context, state) {
          if (state is GymnasiumLoadedState) {
            return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildGymnasiumLocationLoaded(state));
          } else {
            return Loading();
          }
        },
      );
    } else
      return Container();
  }
}
