import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taxi/src/fire_base/users.dart';
import 'package:taxi/src/resources/dialog/loading_dialog.dart';
import 'package:taxi/src/resources/home_page.dart';
import 'package:taxi/src/resources/register_page.dart';

import '../model/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 140,
                ),
                Image.asset('assets/ic_car_green.png'),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 6),
                  child: Text(
                    "Welcome back!",
                    style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                  ),
                ),
                const Text(
                  "Login to continue using Taxi",
                  style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 145, 0, 20),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Required";
                      }
                      if (val.length != 10) {
                        return "Invalid number format";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: "Phone",
                        hintText: "07XXXXXXXX",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
                TextFormField(
                  controller: _passController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
                Container(
                  /*constraints:
                      BoxConstraints.loose(const Size(double.infinity, 30)),*/
                  alignment: AlignmentDirectional.centerEnd,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RaisedButton(
                      onPressed: _onLoginClick,
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: const Color(0xff3277D8),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: RichText(
                    text: TextSpan(
                        text: "New user? ",
                        style: const TextStyle(
                            color: Color(0xff606470), fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                              text: "Sign up for a new account",
                              style: const TextStyle(
                                  color: Color(0xff3277D8), fontSize: 16))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginClick() async {
    var validated = formkey.currentState!.validate();
    if (!validated) {
      return;
    }
    String email = _emailController.text;
    String pass = _passController.text;
    LoadingDialog.showLoadingDialog(context, "Loading...");
    User? user = await login(_emailController.text, _passController.text);
    LoadingDialog.hideLoadingDialog(context);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error connecting to server"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (user.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Incorrect credentials"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    await saveUserFile(user);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage(user)),
        (route) => false);
  }
}
