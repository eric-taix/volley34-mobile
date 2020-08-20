import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  String _mapStyle;

  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/maps/dark_style_map.txt').then((mapStyle) {
      if (mapController != null) {
        mapController.setMapStyle(mapStyle);
      } else {
        _mapStyle = mapStyle;
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
            children: <Widget>[
              GoogleMap(
                  initialCameraPosition: _initialLocation,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapController.setMapStyle(_mapStyle);
                    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(43.6185867, 3.9164595), zoom: 15)));
                  },
                  gestureRecognizers: [
                    Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),)
                  ].toSet()),
            ],
          ),
      ),
    );
  }
}
