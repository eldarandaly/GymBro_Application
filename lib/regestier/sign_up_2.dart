import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/sign_in/signin.dart';
import '../data_base/database.dart';
import '../data_base/authentication.dart';
import '../user_data.dart';

class signup2 extends StatefulWidget {
  MyUser savedUser;
  signup2({key, required this.savedUser}) : super(key: key);
  @override
  State<signup2> createState() => _signup2State();
}

class _signup2State extends State<signup2> {
  final _formkey = GlobalKey<FormState>();
  String cholestrollevel = "";
  String bloodsugar = "";
  String bloodpressaure = "";
  String email = "";
  String username = "";
  String password = "";
  String confirmpassword = "";
  String dateofbirth = "";
  String gender = "";
  String error = "";
  String phonenumber = "";
  String gradine = "";
  String gradineName = "";

  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Container(height: 50),
      Form(
          key: _formkey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        Container(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? "Please fill this textbox" : null,
                          onChanged: (val) {
                            setState(() => cholestrollevel = val);
                          },
                          decoration: const InputDecoration(
                              labelText: 'Cholestrol level',
                              icon: Icon(Icons.oil_barrel),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        Container(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? "Please fill this textbox" : null,
                          onChanged: (val) {
                            setState(() => bloodsugar = val);
                          },
                          decoration: const InputDecoration(
                              labelText: 'Blood sugar',
                              icon: Icon(Icons.bloodtype_outlined),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        Container(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? "Please fill this textbox" : null,
                          onChanged: (val) {
                            setState(() => bloodpressaure = val);
                          },
                          decoration: const InputDecoration(
                              labelText: 'Blood pressaure',
                              icon: Icon(Icons.thumbs_up_down_outlined),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        Container(height: 15),
                        TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? "Please fill this textbox" : null,
                          onChanged: (val) {
                            setState(() => gradineName = val);
                          },
                          decoration: const InputDecoration(
                              labelText: 'Guardian  Name',
                              icon: Icon(Icons.shield_outlined),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        Container(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val!.isEmpty ? "Please fill this textbox" : null,
                          onChanged: (val) {
                            setState(() => gradine = val);
                          },
                          decoration: const InputDecoration(
                              labelText: 'Gradine Number',
                              icon: Icon(Icons.thumbs_up_down_outlined),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ])),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 25),
          ElevatedButton(
              onPressed: () async {
                // if (_formkey.currentState!.validate()) {
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: const Text("Aleart"),
                //         content: Text('Please Enter All the Info.'),
                //         actions: <Widget>[
                //           ElevatedButton(
                //             child: const Text("OK"),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Aleart"),
                      content: Text('Saved ${WhatUser.email}'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                // }

                dynamic result =
                    await _auth.signupwithemailandpassword(email, password);
                await DatabaseService(uid: widget.savedUser.email)
                    .updateUserData(
                        widget.savedUser.email,
                        widget.savedUser.username,
                        widget.savedUser.password,
                        widget.savedUser.confirmpassword,
                        widget.savedUser.phonenumber,
                        widget.savedUser.gender,
                        widget.savedUser.dateofbirth,
                        cholestrollevel,
                        bloodpressaure,
                        bloodsugar,
                        gradine,
                        gradineName,
                        widget.savedUser.isAdoctor);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(250.0),
                  backgroundColor: Colors.blueAccent),
              child: const Text("Save", style: TextStyle(color: Colors.white))),
          Container(height: 20),
        ],
      )
    ]));
  }
}
