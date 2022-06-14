import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi/src/model/user.dart';
import 'package:taxi/src/resources/dialog/loading_dialog.dart';
import 'package:uuid/uuid.dart';

import '../fire_base/users.dart';
import '../model/place_item_res.dart';
import '../model/step_res.dart';
import '../model/trip_info_res.dart';
import '../providers/markers.dart';
import '../providers/polylines.dart';
import '../repository/place_service.dart';
import '../services/location.dart';

class HomePortion extends StatefulWidget {
  final User user;
  const HomePortion(this.user, {Key? key}) : super(key: key);

  @override
  State<HomePortion> createState() => _HomePortionState();
}

GoogleMapController? _mapController;

class _HomePortionState extends State<HomePortion> {
  var _tripDistance = 0;
  final Map<String, Marker> _markers = <String, Marker>{};
  final Map<String, Polyline> polylines = {};

  late Stream<Position> currPosition;
  Future<dynamic>? position;
  Future<Uint8List>? vehicle;
  PlaceItemRes? from;
  TextEditingController fromtext = TextEditingController();
  PlaceItemRes? to;
  TextEditingController totext = TextEditingController();
  late String token;
  @override
  void initState() {
    token = const Uuid().v1();
    position = getCurrentLocation();
    vehicle = getImageBytes("assets/ic_car_green.png", 120);
    //widget.stream.listen((pos) {});
    currPosition = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 5)));
    currPosition.listen((pos) {
      /*getLocationFromCoordinates(pos).then((value) {
        if (value != null) {
          fromtext.text = value;
        }
      });*/
      if (mounted) {
        context.read<MarkersProvider>().addMarker(Marker(
            markerId: const MarkerId("mylocation"),
            position: LatLng(pos.latitude, pos.longitude),
            icon: BitmapDescriptor.defaultMarker));
      }
      updateUserLocation(widget.user, pos).then((val) {
        if (mounted) {
          if (val) {
            if (widget.user.driver == false) {
              getNearbyDrivers(pos).then((drivers) async {
                Uint8List icon = await vehicle!;
                for (int n = 0; n < drivers.length; ++n) {
                  context.read<MarkersProvider>().addMarker(
                        Marker(
                            markerId: MarkerId(drivers[n].id!),
                            onTap: () {
                              showDriverInfo(drivers[n]);
                            },
                            infoWindow: InfoWindow(
                                title: drivers[n].name,
                                snippet: drivers[n].phone,
                                onTap: () {}),
                            position: LatLng(
                                drivers[n].latitude!, drivers[n].longitude!),
                            icon: BitmapDescriptor.fromBytes(icon)),
                      );
                }
              });
            }
          }
        }
      });
    });
    FirebaseFirestore.instance
        .doc("Users/${widget.user.id}")
        .snapshots()
        .listen(
      (event) {
        if (widget.user.driver) {
          var dummy = User.fromJson(event.data()!);
          if (dummy.requester != null) {
            FirebaseFirestore.instance
                .doc("Trips/${dummy.requester}")
                .get()
                .then((value) {
              var trip = value.data();
            });
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: FutureBuilder<dynamic>(
          future: position,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.runtimeType != Position) {
              return const Center(child: Text("Enable location services"));
            }
            Position positiondata = snapshot.data!;
            return Stack(
              children: <Widget>[
                GoogleMaps(positiondata),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        title: Text(
                          (widget.user.driver == true) ? "Driver" : "Passenger",
                          style: const TextStyle(color: Colors.black),
                        ),
                        leading: FlatButton(
                            onPressed: () {
                              //print("click menu");
                              Scaffold.of(context).openDrawer();
                            },
                            child: Image.asset("assets/ic_menu.png")),
                        actions: <Widget>[Image.asset("assets/ic_notify.png")],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child:
                              //RidePicker(onPlaceSelected, positiondata, token),
                              Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TypeAheadFormField<String>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            controller: fromtext,
                                            decoration: const InputDecoration(
                                                icon: Icon(Icons.location_on),
                                                border: InputBorder.none,
                                                hintText: "From")),
                                    suggestionsCallback: (val) {
                                      return getGoogleLocationAddresses(
                                          val, token, locale: {
                                        "lat": positiondata.latitude,
                                        "lon": positiondata.longitude
                                      });
                                    },
                                    itemBuilder: (context, value) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(value),
                                          ),
                                          const Divider()
                                        ],
                                      );
                                    },
                                    onSuggestionSelected: (val) {
                                      fromtext.text = val;
                                      getAddressData(val).then((place) {
                                        from = place;
                                        context
                                            .read<MarkersProvider>()
                                            .addMarker(Marker(
                                                markerId: const MarkerId(
                                                    "from_address"),
                                                position: LatLng(
                                                    place!.lat, place.lng),
                                                icon: BitmapDescriptor
                                                    .defaultMarkerWithHue(
                                                        BitmapDescriptor
                                                            .hueGreen)));
                                        onPlaceSelected(place, true);
                                      });
                                    }),
                                const Divider(),
                                TypeAheadFormField<String>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            controller: totext,
                                            decoration: const InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.telegram),
                                                border: InputBorder.none,
                                                hintText: "To")),
                                    suggestionsCallback: (val) {
                                      return getGoogleLocationAddresses(
                                          val, token, locale: {
                                        "lat": positiondata.latitude,
                                        "lon": positiondata.longitude
                                      });
                                    },
                                    itemBuilder: (context, value) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(value),
                                          ),
                                          const Divider()
                                        ],
                                      );
                                    },
                                    onSuggestionSelected: (val) {
                                      totext.text = val;
                                      getAddressData(val).then((place) {
                                        to = place;
                                        context
                                            .read<MarkersProvider>()
                                            .addMarker(Marker(
                                                markerId: const MarkerId(
                                                    "to_address"),
                                                position: LatLng(
                                                    place!.lat, place.lng),
                                                icon: BitmapDescriptor
                                                    .defaultMarkerWithHue(
                                                        BitmapDescriptor
                                                            .hueGreen)));
                                        onPlaceSelected(place, false);
                                      });
                                    })
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                (widget.user.driver == false)
                    ? Positioned(
                        left: 20,
                        //right: 20,
                        bottom: 40,
                        //height: 248,
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: ElevatedButton(
                            child: const Text("Request"),
                            onPressed: () async {
                              bool response = await request(widget.user.id!);
                              if (!response) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Please try again later"),
                                  backgroundColor: Colors.red,
                                ));
                                return;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Your request has been made"),
                                ));
                              }
                            },
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            );
          }),
    );
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    if (context.read<MarkersProvider>().markers["from_address"] == null ||
        context.read<MarkersProvider>().markers["to_address"] == null) {
      return;
    }
    //var mkId = fromAddress ? "from_address" : "to_address";
    //_addMarker(mkId, place);
    _moveCamera();
    _checkDrawPolyline();
  }

  void _moveCamera() {
    if (context.read<MarkersProvider>().markers["from_address"] != null &&
        context.read<MarkersProvider>().markers["to_address"] != null) {
      var fromLatLng =
          context.read<MarkersProvider>().markers["from_address"]!.position;
      var toLatLng =
          context.read<MarkersProvider>().markers["to_address"]!.position;

      double sLat, sLng, nLat, nLng;
      if (fromLatLng.latitude <= toLatLng.latitude) {
        sLat = fromLatLng.latitude;
        nLat = toLatLng.latitude;
      } else {
        sLat = toLatLng.latitude;
        nLat = fromLatLng.latitude;
      }

      if (fromLatLng.longitude <= toLatLng.longitude) {
        sLng = fromLatLng.longitude;
        nLng = toLatLng.longitude;
      } else {
        sLng = toLatLng.longitude;
        nLng = fromLatLng.longitude;
      }

      LatLngBounds bounds = LatLngBounds(
          northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      _mapController!.animateCamera(
          CameraUpdate.newLatLng(_markers.values.elementAt(0).position));
    }
  }

  Future<Uint8List> getImageBytes(String assetpath, int width) async {
    ByteData data = await rootBundle.load(assetpath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _checkDrawPolyline() {
//  remove old polyline
    polylines.clear();

    if (context.read<MarkersProvider>().markers["from_address"] != null &&
        context.read<MarkersProvider>().markers["to_address"] != null) {
      var from =
          context.read<MarkersProvider>().markers["from_address"]!.position;
      var to = context.read<MarkersProvider>().markers["to_address"]!.position;
      PlaceService.getStep(
              from.latitude, from.longitude, to.latitude, to.longitude)
          .then((vl) {
        TripInfoRes infoRes = vl;

        _tripDistance = infoRes.distance;
        //setState(() {});
        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = [];
        for (var t in rs) {
          paths.add(
              LatLng(t.startLocation!.latitude, t.startLocation!.longitude));
          paths.add(LatLng(t.endLocation!.latitude, t.endLocation!.longitude));
        }
        context.read<PolylineProvider>().setPolylines({
          "${from.toString()}${to.toString()}": Polyline(
              points: paths,
              polylineId: PolylineId(from.toString() + to.toString()),
              color: const Color(0xff3adf00),
              width: 2)
        });
//        print(paths)
      });
    }
  }

  void showDriverInfo(User user) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(
                      radius: 40,
                      child: (user.dp == null)
                          ? const Icon(Icons.person, size: 28)
                          : null,
                      foregroundImage:
                          (user.dp == null) ? null : NetworkImage(user.dp!),
                    ),
                    Text(user.name!),
                    Text("${user.rides} trips"),
                    (user.rating == 0.0)
                        ? const Text("This driver has no ratings yet")
                        : RatingBarIndicator(
                            itemCount: 5,
                            rating: user.rating,
                            itemBuilder: (context, index) {
                              return const Icon(Icons.star,
                                  color: Colors.amber);
                            }),
                    InkWell(
                      onTap: () async {},
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          width: double.infinity,
                          height: 40,
                          alignment: Alignment.center,
                          child: const Text("Request",
                              style: TextStyle(color: Colors.white)),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                          )),
                    )
                  ])));
        });
  }

  Future<bool> request(String driver) async {
    if (from == null || to == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a source and destination"),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    LoadingDialog.showLoadingDialog(context, "Requesting...");
    bool response = await requestDriver(from!, to!, widget.user.id!);
    LoadingDialog.hideLoadingDialog(context);
    return response;
  }
}

class GoogleMaps extends StatelessWidget {
  final Position position;
  const GoogleMaps(this.position, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<MarkersProvider, PolylineProvider>(
        builder: (context, markers, polylines, child) {
      return GoogleMap(
          mapToolbarEnabled: false,
          zoomControlsEnabled: true,
          markers: Set.from(markers.markers.values),
          polylines: Set.from(polylines.polylines.values),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 15));
    });
  }
}
