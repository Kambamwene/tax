class User {
  String? id;
  String? name;
  String? email;
  String? dp;
  String? license;
  bool driver = false;
  double? latitude;
  double? longitude;
  String? password;
  String? ride_type;
  String? phone;
  String? NIN;
  int? seats;
  int? raters;
  int rides = 0;
  double rating = 0.0;
  String? requester;
  bool verified = true;
  bool transit = false;
  User();
  factory User.fromJson(Map<String, dynamic> map) {
    User user = User();
    user.id = map['id'];
    user.license = map['license'];
    user.ride_type = map['ride_type'];
    user.latitude = map['latitude'];
    user.longitude = map['longitude'];
    user.NIN = map['NIN'];
    user.dp = map['dp'];
    if (map["rides"] != null) {
      user.rides = map["rides"];
    }
    if (map["rating"] != null) {
      user.rating = map["rating"];
    }
    user.raters = map["raters"];
    user.seats = map["seats"];
    if (map['rating'] != null) {
      user.rating = map['rating'];
    }
    if (map['driver'] != null) {
      user.driver = map['driver'];
    }
    user.name = map['name'];
    if (map['verified'] != null) {
      user.verified = false;
    }
    user.requester = map["requester"];
    user.email = map['email'];
    user.phone = map['phone'];
    user.password = map['password'];
    if (map['transit'] != null) {
      user.transit = map['transit'];
    }
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "longitude": longitude,
      "latitude": latitude,
      "dp": dp,
      "driver": driver,
      "name": name,
      "license": license,
      "verified": verified,
      "email": email,
      "seats": seats,
      "password": password,
      "phone": phone,
      "rides": rides,
      "transit": transit,
      "ride_type": ride_type,
      "NIN": NIN,
      "rating": rating
    };
  }
}
