import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';

class MapProvider {
  final LocalStorage _localeStorage = localStorage;

  Future<CameraPosition?> loadCameraPosition(String mapName) async {
    return null;
    //return CameraPosition.fromMap(_localeStorage.getItem("${mapName}_map"));
  }

  void saveCameraPosition(String mapName, CameraPosition cameraPosition) async {
    //_localeStorage.setItem("${mapName}_map", cameraPosition.toMap());
  }
}
