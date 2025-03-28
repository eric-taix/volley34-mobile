import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v34/commons/marker/map-marker.dart';
import 'package:v34/models/gymnasium.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/extensions.dart';

typedef GymnasiumSelectedCallback = void Function(Gymnasium gymnasiumCode);

class GymnasiumMap extends StatefulWidget {
  final List<Gymnasium>? gymnasiums;
  final String? currentGymnasiumCode;
  final GymnasiumSelectedCallback onGymnasiumSelected;

  GymnasiumMap(
      {Key? key,
      required this.gymnasiums,
      required String? currentGymnasiumCode,
      required this.onGymnasiumSelected})
      : this.currentGymnasiumCode =
            currentGymnasiumCode ?? gymnasiums![0].gymnasiumCode,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _GymnasiumMapState();
}

class _GymnasiumMapState extends State<GymnasiumMap> {
  late Repository _repository;
  GoogleMapController? _mapController;

  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(43.6101248, 3.8039496), zoom: 11);

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GymnasiumMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentGymnasiumCode != widget.currentGymnasiumCode ||
        oldWidget.gymnasiums != widget.gymnasiums) {
      _showCurrentGymnasium();
    }
  }

  void _showCurrentGymnasium() {
    if (widget.gymnasiums != null) {
      Gymnasium currentGymnasium = widget.gymnasiums!.firstWhere(
          (gymnasium) => gymnasium.gymnasiumCode == widget.currentGymnasiumCode,
          orElse: () => widget.gymnasiums![0]);
      _mapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(currentGymnasium.latitude!, currentGymnasium.longitude!)));
    }
  }

  _onCameraMove(CameraPosition cameraPosition) {
    _repository.saveCameraPosition("gymnasiums", cameraPosition);
  }

  _gotoCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high))
        .then((Position position) async {
      double currentZoomLevel = await _mapController!.getZoomLevel();
      setState(() {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: currentZoomLevel,
            ),
          ),
        );
      });
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _repository.loadCameraPosition("gymnasiums").then((savedCameraPosition) {
      if (savedCameraPosition != null) {
        _mapController!
            .moveCamera(CameraUpdate.zoomTo(savedCameraPosition.zoom))
            .then((_) => _showCurrentGymnasium());
      }
    });
    _showCurrentGymnasium();
  }

  void _onMarkerTap(Gymnasium gymnasium) {
    widget.onGymnasiumSelected(gymnasium);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
                markers: widget.gymnasiums!
                    .map(
                      (gymnasium) => Marker(
                        markerId: MarkerId(gymnasium.gymnasiumCode!),
                        position: LatLng(
                          gymnasium.latitude!,
                          gymnasium.longitude!,
                        ),
                        alpha: gymnasium.gymnasiumCode ==
                                widget.currentGymnasiumCode
                            ? 1.0
                            : 1,
                        onTap: () => _onMarkerTap(gymnasium),
                        zIndex: gymnasium.gymnasiumCode ==
                                widget.currentGymnasiumCode
                            ? 1.0
                            : 0.0,
                        icon: gymnasium.gymnasiumCode ==
                                widget.currentGymnasiumCode
                            ? BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure)
                            : BitmapDescriptor.defaultMarker,
                      ),
                    )
                    .toSet(),
                initialCameraPosition: _initialLocation,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: _onMapCreated,
                onCameraMove: _onCameraMove,
                gestureRecognizers: [
                  Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  )
                ].toSet()),
            Positioned(
                right: 8,
                top: 53,
                child: FloatingActionButton(
                  heroTag: "hero-btn-my-location",
                  mini: true,
                  child: Icon(Icons.my_location),
                  onPressed: () {
                    _gotoCurrentLocation();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
