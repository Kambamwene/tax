import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi/src/blocs/place_bloc.dart';
import 'package:taxi/src/model/place_item_res.dart';
import 'package:taxi/src/services/location.dart';

class RidePickerPage extends StatefulWidget {
  final String selectedAddress;
  final Function(PlaceItemRes, bool) onSelected;
  final Position position;
  final String token;
  final bool _isFromAddress;
  const RidePickerPage(this.selectedAddress, this.onSelected,
      this._isFromAddress, this.position, this.token);

  @override
  _RidePickerPageState createState() => _RidePickerPageState();
}

class _RidePickerPageState extends State<RidePickerPage> {
  var _addressController;
  var placeBloc = PlaceBloc();

  @override
  void initState() {
    _addressController = TextEditingController(text: widget.selectedAddress);
    super.initState();
  }

  @override
  void dispose() {
    placeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: const Color(0xfff8f8f8),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                        height: 60,
                        child: Center(
                          child: Image.asset("assets/ic_location_black.png"),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 40,
                        height: 60,
                        child: Center(
                          child: FlatButton(
                              onPressed: () {
                                _addressController.text = "";
                              },
                              child: Image.asset("assets/ic_remove_x.png")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 50),
                        child: TypeAheadField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _addressController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (str) {
                              placeBloc.searchPlace(str);
                            },
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xff323643)),
                          ),
                          suggestionsCallback: (val) {
                            return getGoogleLocationAddresses(val, widget.token,
                                locale: {
                                  "lat": widget.position.latitude,
                                  "lon": widget.position.longitude
                                });
                          },
                          itemBuilder: (context, value) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(value),
                                  ),
                                  const Divider()
                                ]);
                          },
                          onSuggestionSelected: (value) async {
                            _addressController.text = value;
                            PlaceItemRes? place = await getAddressData(value);
                            if (place != null) {
                              widget.onSelected(place, widget._isFromAddress);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: StreamBuilder<dynamic>(
                  stream: placeBloc.placeStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.toString());
                      if (snapshot.data == "start") {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      print(snapshot.data.toString());
                      List<PlaceItemRes> places = snapshot.data!;
                      return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  (places.elementAt(index).address == null)
                                      ? ""
                                      : places.elementAt(index).address),
                              subtitle: Text(
                                  (places.elementAt(index).address == null)
                                      ? ""
                                      : places.elementAt(index).address),
                              onTap: () {
                                print("on tap");
                                Navigator.of(context).pop();
                                widget.onSelected(places.elementAt(index),
                                    widget._isFromAddress);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(
                                height: 1,
                                color: Color(0xfff5f5f5),
                              ),
                          itemCount: places.length);
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
