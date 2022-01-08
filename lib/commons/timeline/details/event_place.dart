import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/marker/map-marker.dart';
import 'package:v34/models/event.dart';
import 'package:v34/pages/dashboard/blocs/gymnasium_bloc.dart';
import 'package:v34/utils/extensions.dart';
import 'package:v34/utils/launch.dart';

class EventPlace extends StatefulWidget {
  final Event event;
  final VoidCallback? onCameraMoveStarted;

  const EventPlace({Key? key, required this.event, this.onCameraMoveStarted}) : super(key: key);

  @override
  _EventPlaceState createState() => _EventPlaceState();
}

class _EventPlaceState extends State<EventPlace> {
  String? _rawMapStyle;
  String? _currentMapStyle;
  GoogleMapController? _mapController;
  BitmapDescriptor? _marker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rootBundle.loadString('assets/maps/map_style.txt').then((mapStyle) {
      _rawMapStyle = mapStyle;
      _applyMapStyle(context);
    });
    _loadMarker();
  }

  void _loadMarker() {
    MapMarker(
      size: 120,
      borderColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Colors.white,
      pinLength: 16,
      borderWidth: 8,
    ).bitmapDescriptor.then(
      (bitmap) {
        setState(() {
          _marker = bitmap;
        });
      },
    );
  }

  @override
  void dispose() {
    if (_mapController != null) _mapController!.dispose();
    super.dispose();
  }

  void _applyMapStyle(BuildContext buildContext) {
    if (_rawMapStyle != null) {
      ThemeData themeData = Theme.of(buildContext);
      _currentMapStyle = _rawMapStyle!
          .replaceAll("{appBarTheme.color}", themeData.appBarTheme.backgroundColor!.toHexWithoutAlpha())
          .replaceAll("{canvasColor}", themeData.canvasColor.toHexWithoutAlpha())
          .replaceAll("{colorScheme.primaryVariant}", themeData.colorScheme.primaryVariant.toHexWithoutAlpha())
          .replaceAll("{textTheme.bodyText1}", themeData.textTheme.bodyText1!.color!.toHexWithoutAlpha())
          .replaceAll("{textTheme.bodyText2}", themeData.textTheme.bodyText2!.color!.toHexWithoutAlpha());
      if (_mapController != null) {
        _mapController!.setMapStyle(_currentMapStyle);
      }
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
            onTap: () => launchRoute(context, state.gymnasium, route: false),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AbsorbPointer(
                absorbing: true,
                child: GoogleMap(
                    markers: [
                      Marker(
                          markerId: MarkerId(state.gymnasium.gymnasiumCode!),
                          position: LatLng(state.gymnasium.latitude!, state.gymnasium.longitude!),
                          icon: _marker ?? BitmapDescriptor.defaultMarkerWithHue(100))
                    ].toSet(),
                    initialCameraPosition:
                        CameraPosition(target: LatLng(state.gymnasium.latitude!, state.gymnasium.longitude!), zoom: 9),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: _onMapCreated,
                    onCameraMoveStarted: () =>
                        widget.onCameraMoveStarted != null ? widget.onCameraMoveStarted!() : null,
                    gestureRecognizers: [
                      Factory<OneSequenceGestureRecognizer>(
                        () => new EagerGestureRecognizer(),
                      )
                    ].toSet()),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0, top: 8.0, bottom: 58),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: () => launchRoute(context, state.gymnasium, route: true),
                  icon: Icon(
                    Icons.directions,
                    size: 28,
                  ),
                  label: Text("Itinéraire"),
                ),
              ),
              if (state.gymnasium.phone != null && state.gymnasium.phone!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton.icon(
                    icon: Icon(Icons.phone),
                    label: Text("Appeler"),
                    onPressed: () => launchURL("tel:${state.gymnasium.phone}"),
                  ),
                ),
            ],
          ),
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
      return BlocBuilder<GymnasiumBloc, GymnasiumState>(
        builder: (context, dynamic state) {
          if (state is GymnasiumLoadedState) {
            return Padding(padding: const EdgeInsets.only(top: 8.0), child: _buildGymnasiumLocationLoaded(state));
          } else {
            return Loading();
          }
        },
      );
    } else
      return Container();
  }
}
