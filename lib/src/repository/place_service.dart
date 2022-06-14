import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:taxi/src/config/configuration.dart';
import 'dart:convert';

import 'package:taxi/src/model/place_item_res.dart';
import 'package:taxi/src/model/step_res.dart';
import 'package:taxi/src/model/trip_info_res.dart';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=" +
            Configs.ggKEY2 +
            "&language=vi&region=VN&query=" +
            Uri.encodeQueryComponent(keyword);

    print("search >>: " + url);
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return PlaceItemRes.fromJson(json.decode(res.body));
    } else {
      return [];
    }
  }

  static Future<dynamic> getStep(
      double lat, double lng, double tolat, double tolng) async {
    String strOrigin = "origin=" + lat.toString() + "," + lng.toString();
    // Destination of route
    String strDest = "destination=" + tolat.toString() + "," + tolng.toString();
    // Sensor enabled
    String sensor = "sensor=false";
    String mode = "mode=driving";
    // Building the parameters to the web service
    String parameters = strOrigin + "&" + strDest + "&" + sensor + "&" + mode;
    // Output format
    String output = "json";
    // Building the url to the web service
    String url = "https://maps.googleapis.com/maps/api/directions/" +
        output +
        "?" +
        parameters +
        "&key=" +
        Configs.ggKEY2;

    print(url);
    const JsonDecoder _decoder = JsonDecoder();
    return http.get(Uri.parse(url)).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
//      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw Exception(res);
      }

      TripInfoRes tripInfoRes;
      try {
        var json = _decoder.convert(res);
        int distance = json["routes"][0]["legs"][0]["distance"]["value"];
        List<StepsRes> steps =
            _parseSteps(json["routes"][0]["legs"][0]["steps"]);

        tripInfoRes = TripInfoRes(distance, steps);
      } catch (e) {
        throw Exception(res);
      }

      return tripInfoRes;
    });
  }

  static List<StepsRes> _parseSteps(final responseBody) {
    var list =
        responseBody.map<StepsRes>((json) => StepsRes.fromJson(json)).toList();

    return list;
  }
}
