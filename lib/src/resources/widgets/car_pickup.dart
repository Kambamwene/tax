/*import 'package:flutter/material.dart';
import 'package:taxi/src/blocs/car_pickup_bloc.dart';

class CarPickup extends StatefulWidget {
  final int distance;
  const CarPickup(this.distance);

  @override
  _CarPickupState createState() => _CarPickupState();
}

class _CarPickupState extends State<CarPickup> {
  //var carBloc = CarPickupBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //stream: carBloc.stream,
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            /*Container(
              constraints: const BoxConstraints.expand(height: 137),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return FlatButton(
                    color: carBloc.isSelected(index)
                        ? const Color(0x3000ffff)
                        : Colors.white,
                    onPressed: () {
                      carBloc.selectItem(index);
                    },
                    child: Container(
                      constraints: const BoxConstraints.expand(width: 120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                                color: Color(0xff323643),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Text(
                              carBloc.carList!.elementAt(index).name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            padding: const EdgeInsets.all(2),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xfff7f7f7),
                            ),
                            width: 64,
                            height: 64,
                            child: Center(
                              child: Image.asset(
                                  carBloc.carList!.elementAt(index).assetsName),
                            ),
                          ),
                          Text(
                            "\$" +
                                carBloc.carList!
                                    .elementAt(index)
                                    .pricePerKM
                                    .toString(),
                            style: const TextStyle(
                                color: Color(0xff606470), fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: carBloc.carList!.length,
                scrollDirection: Axis.horizontal,
              ),
            ),*/
            /*Positioned(
              bottom: 48,
              right: 0,
              left: 0,
              height: 50,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total (" + _getDistanceInfo() + "): ",
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      "Tzs " + _getTotal().toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
            ),*/
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: RaisedButton(
                  onPressed: () {},
                  color: const Color(0xff3277D8),
                  child: const Text(
                    "Request Taxi",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  String _getDistanceInfo() {
    double distanceInKM = widget.distance / 1000;
    return distanceInKM.toString() + " km";
  }

  double _getTotal() {
    double distanceInKM = widget.distance / 1000;
    //return (distanceInKM * carBloc.getCurrentCar().pricePerKM);
  }
}*/
