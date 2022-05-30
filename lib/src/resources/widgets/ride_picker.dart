import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi/src/model/place_item_res.dart';
import 'package:taxi/src/resources/ride_picker_page.dart';

class RidePicker extends StatefulWidget {
  final Function(PlaceItemRes, bool) onSelected;
  final Position position;
  final String token;
  const RidePicker(this.onSelected, this.position, this.token);

  @override
  _RidePickerState createState() => _RidePickerState();
}

class _RidePickerState extends State<RidePicker> {
  PlaceItemRes? fromAddress;
  PlaceItemRes? toAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color(0x88999999),
              offset: Offset(0, 5),
              blurRadius: 5.0,
            ),
          ]),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RidePickerPage(
                            fromAddress == null ? "" : fromAddress!.name!,
                            (place, isFrom) {
                          widget.onSelected(place, isFrom);
                          setState(() {
                            fromAddress = place;
                          });
                        }, true, widget.position, widget.token)));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_location_black.png"),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_remove_x.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 50),
                      child: Text(
                        fromAddress == null ? "From" : fromAddress!.name!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RidePickerPage(
                            toAddress == null ? "" : toAddress!.name!,
                            (place, isFrom) {
                          widget.onSelected(place, isFrom);

                          setState(() {
                            toAddress = place;
                          });
                        }, false, widget.position, widget.token)));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_map_nav.png"),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_remove_x.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 50),
                      child: Text(
                        toAddress == null ? "To" : toAddress!.address,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
