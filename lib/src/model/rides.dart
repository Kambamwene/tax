class Ride {
  String? id;
  String? from;
  String? to;
  String? driver;
  double? price;
  String? passenger;
  Ride();
  factory Ride.fromJson(Map<String, dynamic> map) {
    Ride ride = Ride();
    ride.driver = map['driver'];
    ride.passenger = map["passenger"];
    ride.price = map["price"];
    ride.from = map['from'];
    ride.to = map["to"];
    return ride;
    //ride.from=
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "driver": driver,
      "passenger": passenger,
      "to": to,
      "from": from,
      "price": price
    };
  }
}
