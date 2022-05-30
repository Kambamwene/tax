import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taxi/src/resources/dialog/loading_dialog.dart';
import 'package:taxi/src/resources/home_page.dart';

import '../fire_base/users.dart';
import '../model/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _NIDAController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController license = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  bool driver = false;
  String type = "car";
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
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
                Image.asset('assets/ic_car_red.png'),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 6),
                  child: Text(
                    "Welcome Aboard!",
                    style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                  ),
                ),
                const Text(
                  "Sign up with Taxi in simple steps",
                  style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: const InputDecoration(
                        //errorText: snapshot.hasError ? "Error" : null,
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  decoration: const InputDecoration(
                      labelText: "Phone Number",
                      hintText: "07XXXXXXXX",
                      //errorText: snapshot.hasError ? "Error" : null,
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: "Email",
                        //errorText: snapshot.hasError ? "Error" : null,
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: DropdownButtonFormField<bool>(
                      value: driver,
                      items: const [
                        DropdownMenuItem(child: Text("User"), value: false),
                        DropdownMenuItem(child: Text("Driver"), value: true)
                      ],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.toggle_on)),
                      onChanged: (value) {
                        setState(() {
                          driver = value!;
                        });
                      }),
                ),
                Builder(builder: (context) {
                  if (driver) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.car_rental),
                                border: OutlineInputBorder()),
                            value: type,
                            items: const [
                              DropdownMenuItem(
                                  child: Text("Car"), value: "car"),
                              DropdownMenuItem(
                                  child: Text("Bajaji"), value: "bajaji"),
                              DropdownMenuItem(
                                  child: Text("Boda"), value: "boda"),
                            ],
                            onChanged: (val) {
                              type = val!;
                            }),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: TextFormField(
                            controller: license,
                            //obscureText: true,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            decoration: const InputDecoration(
                                //errorText: snapshot.hasError ? "Error" : null,
                                labelText: "License Number",
                                prefixIcon: Icon(Icons.numbers),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xffCED0D2), width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: TextFormField(
                            controller: _NIDAController,
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            decoration: const InputDecoration(
                                labelText: "NIN",
                                //errorText: snapshot.hasError ? "Error" : null,
                                prefixIcon: Icon(Icons.credit_card),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xffCED0D2), width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Required";
                      }
                      if (val.length < 4) {
                        return "Password is too short";
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: const InputDecoration(
                        //errorText: snapshot.hasError ? "Error" : null,
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RaisedButton(
                      onPressed: _onSignUpClicked,
                      child: const Text(
                        "Signup",
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
                        text: "Already a User? ",
                        style: const TextStyle(
                            color: Color(0xff606470), fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
                                },
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

  _onSignUpClicked() async {
    var isValid = formkey.currentState!.validate();
    if (isValid) {
      // create user
      // loading dialog
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      User user = User();
      user.name = _nameController.text;
      user.email = _emailController.text;
      user.phone = _phoneController.text;
      user.password = _passController.text;
      user.verified = true;
      user.transit = false;
      if (driver) {
        user.ride_type = type;
        user.driver = driver;
        user.license = license.text;
        user.verified = false;
        user.NIN = _NIDAController.text;
      }
      User? response = await addUser(user);
      LoadingDialog.hideLoadingDialog(context);
      if (response == null) {
        //scaffoldkey.currentContext.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error connecting to server"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      if (response.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Couldn't sign you up"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      await saveUserFile(response);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage(user)),
          (route) => false);
    }
  }
}
