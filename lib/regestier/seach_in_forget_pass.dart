import 'package:flutter/material.dart';
import '/sign_in/signin.dart';

class search extends StatelessWidget {
  const search({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TeleHealthCare",
              style: TextStyle(
                  color: Colors.lightBlue, fontWeight: FontWeight.w800)),
          backgroundColor: Colors.grey[900],
          centerTitle: true,
        ),
        body: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          Container(height: 50),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "  New Password",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Container(height: 15),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                Container(height: 15),
                Text(
                  "  Confirm new password",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Container(height: 15),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                Container(height: 15)
              ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 15),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(250.0),
                      backgroundColor: Colors.blueAccent)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(250.0),
                      backgroundColor: Colors.grey)),
              Container(height: 20),
            ],
          )
        ]));
  }
}
