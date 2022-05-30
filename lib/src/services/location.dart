import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:taxi/src/config/configuration.dart';
import 'package:taxi/src/model/place_item_res.dart';

Future<dynamic> getCurrentLocation() async {
  var permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.deniedForever) {
    return -1;
  }
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      Geolocator.openLocationSettings();
      return -1;
    }
  }
  return await Geolocator.getCurrentPosition();
}

Future<List<String>> getGoogleLocationAddresses(String query, String token,
    {Map<String, dynamic>? locale}) async {
  if (query.isEmpty) {
    return [];
  }
  try {
    Map<String, String> params = {
      "key": Configs.ggKEY2,
      "input": query,
      "sessiontoken": token,
    };
    if (locale != null) {
      params["location"] = "${locale['lat']},${locale['lon']}";
      params["radius"] = "100000";
    }
    var response = await http
        .get(Uri.https(
            "maps.googleapis.com", "maps/api/place/autocomplete/json", params))
        .timeout(Configs.timeout);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      if (body["status"] == "OK") {
        List<String> places = [];
        List<dynamic> predictions = body["predictions"];
        for (int n = 0; n < predictions.length; ++n) {
          places.add(predictions[n]["description"]);
        }
        return places;
      }
    }
    return [];
  } catch (err) {
    return [];
  }
}

Future<PlaceItemRes?> getAddressData(String address) async {
  try {
    var response = await http.get(Uri.https("maps.googleapis.com",
        "/maps/api/geocode/json", {"key": Configs.ggKEY2, "address": address}));
    if (response.statusCode == 200) {
      Map<String, dynamic> results = json.decode(response.body);
      if (results["status"] == "OK") {
        List<dynamic> addresses = results["results"];
        if (addresses.isNotEmpty) {
          PlaceItemRes place = PlaceItemRes(
              addresses.first["place_id"],
              addresses.first["formatted_address"],
              addresses.first["geometry"]["location"]["lat"],
              addresses.first["geometry"]["location"]["lng"],
              name: address);
          //place.lat=addresses.first["geometry"].location.lat;
          return place;
        }
      }
    }
    return null;
  } catch (err) {
    return null;
  }
}

Future<String?> getLocationFromCoordinates(Position position) async {
  try {
    var response = await http.get(Uri.https(
        "maps.googleapis.com", "/maps/api/geocode/json", {
      "key": Configs.ggKEY2,
      "latlng": "${position.latitude},${position.longitude}"
    }));
    if (response.statusCode == 200) {
      List<dynamic> results = json.decode(response.body)["results"];
      if (results.isNotEmpty) {
        return results.first["formatted_address"];
      }
    }
    return null;
  } catch (err) {
    return null;
  }
}
