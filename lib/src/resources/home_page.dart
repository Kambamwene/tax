import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi/src/providers/pages.dart';
import 'package:taxi/src/resources/home_portion.dart';
import 'package:taxi/src/resources/profile.dart';
import 'package:taxi/src/resources/widgets/home_menu.dart';

import '../model/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage(this.user, {Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //Stream<Position>? currPosition;
  @override
  void initState() {
    /*currPosition = Geolocator.getPositionStream();
    currPosition!.listen((pos) {
      updateUserLocation(widget.user, pos);
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("build UI");
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<PagesWrapper>(builder: (context, page, child) {
        if (page.page == 0) {
          return HomePortion(widget.user);
        }
        if (page.page == 1) {
          return Profile(widget.user);
        }
        return HomePortion(widget.user);
      }),
      drawer: Drawer(
        child: HomeMenu(),
      ),
    );
  }
}
