
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';

class MapProvider {

  final LocalStorage _localeStorage = LocalStorage("v34");

  Future<CameraPosition?> loadCameraPosition(String mapName) async {
    await _localeStorage.ready;
    return CameraPosition.fromMap(_localeStorage.getItem("${mapName}_map"));
  }

  void saveCameraPosition(String mapName, CameraPosition cameraPosition) async {
    await _localeStorage.ready;
    _localeStorage.setItem("${mapName}_map", cameraPosition.toMap());
  }

}
