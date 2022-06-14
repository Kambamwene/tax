import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi/src/fire_base/users.dart';
import 'package:taxi/src/model/user.dart';
import 'package:taxi/src/providers/markers.dart';
import 'package:taxi/src/providers/pages.dart';
import 'package:taxi/src/providers/polylines.dart';
import 'package:taxi/src/resources/home_page.dart';
import 'package:taxi/src/resources/login_page.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User user = await readUserFile();
  //Position? position = await getCurrentLocation();
  runApp(MyApp(MultiProvider(
    providers: [
      ListenableProvider(create: (context) => PolylineProvider()),
      ListenableProvider(create: (context) => MarkersProvider()),
      ListenableProvider(create: (context) => PagesWrapper())
    ],
    child: MaterialApp(
      home: //LoginPage()
          (user.id == null) ? LoginPage() : HomePage(user),
    ),
  )));
}
