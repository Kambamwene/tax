import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersProvider extends ChangeNotifier {
  Map<String, Marker> markers = {};
  void addMarker(Marker marker) {
    markers[marker.markerId.value] = marker;
    notifyListeners();
  }

  void removeMarker(Marker marker) {
    markers.remove(marker);
    notifyListeners();
  }

  void setMarkers(Map<String, Marker> newmarkers) {
    markers = {};
    markers.addAll(newmarkers);
    notifyListeners();
  }
}
