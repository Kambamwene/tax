import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineProvider extends ChangeNotifier {
  Map<String, Polyline> polylines = {};
  void setPolylines(Map<String, Polyline> line) {
    polylines = {};
    polylines.addAll(line);
    notifyListeners();
  }
}
