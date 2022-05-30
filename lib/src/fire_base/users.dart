import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../model/user.dart';

Future<User?> addUser(User user) async {
  try {
    user.id = const Uuid().v1();
    var query = await FirebaseFirestore.instance
        .collection("Users")
        .where("phone", isEqualTo: user.phone)
        .get();
    if (query.size > 0) {
      return User();
    }
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.id!)
        .set(user.toJson());
    return user;
  } catch (err) {
    return null;
  }
}

Future<User?> login(String phone, String password) async {
  try {
    var query = await FirebaseFirestore.instance
        .collection("Users")
        .where("phone", isEqualTo: phone)
        .where("password", isEqualTo: password)
        .get();
    if (query.size == 0) {
      return User();
    }
    var data = query.docs.first.data();
    return User.fromJson(data);
  } catch (err) {
    return null;
  }
}

Future<void> saveUserFile(User user) async {
  Directory dir = await getApplicationDocumentsDirectory();
  String path = dir.path + "/user.dat";
  File file = File(path);
  file.openSync(mode: FileMode.write);
  file.writeAsStringSync(json.encode(user.toJson()));
}

Future<User> readUserFile() async {
  Directory dir = await getApplicationDocumentsDirectory();
  String path = dir.path + "/user.dat";
  File file = File(path);
  if (!file.existsSync()) {
    return User();
  }
  file.openSync(mode: FileMode.read);
  try {
    return User.fromJson(json.decode(file.readAsStringSync()));
  } catch (err) {
    file.deleteSync();
    return User();
  }
}

Future<void> deleteUserFile() async {
  Directory dir = await getApplicationDocumentsDirectory();
  String path = dir.path + "/user.dat";
  File file = File(path);
  if (file.existsSync()) {
    file.deleteSync();
  }
}

Future<bool> updateUserLocation(User user, Position position) async {
  try {
    user.longitude = position.longitude;
    user.latitude = position.latitude;
    await FirebaseFirestore.instance
        .doc("Users/${user.id}")
        .update(user.toJson());
    await saveUserFile(user);
    return true;
  } catch (err) {
    return false;
  }
}

Future<List<User>> getNearbyDrivers(Position position,
    [double radius = 5000]) async {
  try {
    double radiusInKm = radius / 1000;
    double kmInLongitudeDegree = 111.320 * cos(position.latitude / 180.0 * pi);
    double deltaLat = radiusInKm / 111.1;
    double deltaLong = radiusInKm / kmInLongitudeDegree;
    var query = await FirebaseFirestore.instance
        .collection("Users")
        .where("driver", isEqualTo: true)
        .where("verified", isEqualTo: true)
        /*.where("latitude", isLessThanOrEqualTo: position.latitude + deltaLat)
        .where("latitude", isGreaterThanOrEqualTo: position.latitude + deltaLat)
        .where("latitude", isGreaterThanOrEqualTo: position.latitude - deltaLat)
        .where("longitude",
            isGreaterThanOrEqualTo: position.longitude - deltaLong)*/
        .get();
    List<User> drivers = [];
    for (int n = 0; n < query.size; ++n) {
      User user = User.fromJson(query.docs[n].data());
      if (user.latitude! < (position.latitude + deltaLat) &&
          user.latitude! > position.latitude - deltaLat) {
        if (user.longitude! < (position.longitude + deltaLong) &&
            user.longitude! > position.longitude - deltaLong) {
          drivers.add(user);
        }
      }
      //drivers.add(User.fromJson(query.docs[n].data()));
    }
    return drivers;
  } catch (err) {
    return [];
  }
}
