import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
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

  _gotoCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print("Error while going to current location: $e");
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
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapController.setMapStyle(_mapStyle);
                    mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(43.6101248, 3.8039496), zoom: 11)));
                  },
                  gestureRecognizers: [
                    Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),)
                  ].toSet()),
              Positioned(
                right: 8,
                top: 23,
                child: ClipOval(
                  child: Material(
                    color: Theme.of(context).textTheme.button.color,
                    child: InkWell(
                      splashColor: Theme.of(context).buttonColor,
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        _gotoCurrentLocation();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
