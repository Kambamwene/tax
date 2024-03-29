class PlaceItemRes {
  String id;
  String? name;
  String address;
  double lat;
  double lng;
  PlaceItemRes(this.id, this.address, this.lat, this.lng, {this.name});

  static List<PlaceItemRes> fromJson(Map<String, dynamic> json) {
    print("parse data");
    List<PlaceItemRes> rs = [];

    var results = json['results'] as List;
    for (var item in results) {
      var p = PlaceItemRes(
          item['id'],
          item['formatted_address'],
          item['geometry']['location']['lat'],
          item['geometry']['location']['lng']);

      rs.add(p);
    }

    return rs;
  }
}
