import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi/src/fire_base/users.dart';
import 'package:taxi/src/providers/pages.dart';
import 'package:taxi/src/resources/login_page.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text("Home",
                style: TextStyle(fontSize: 18, color: Color(0xff323643))),
            onTap: () {
              context.read<PagesWrapper>().changePage(0);
              Navigator.of(context).pop();
            }),
        ListTile(
            leading: Image.asset("assets/ic_menu_user.png"),
            title: const Text(
              "My Profile",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
            onTap: () {
              context.read<PagesWrapper>().changePage(1);
              Navigator.of(context).pop();
            }),
        ListTile(
          leading: Image.asset("assets/ic_menu_history.png"),
          title: const Text(
            "Ride History",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
          leading: Image.asset("assets/ic_menu_help.png"),
          title: const Text(
            "Help & Supports",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
            leading: Image.asset("assets/ic_menu_logout.png"),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
            onTap: () async {
              await deleteUserFile();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            })
      ],
    );
  }
}
