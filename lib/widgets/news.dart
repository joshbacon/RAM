/*

  This widget is displayed at the top of the home page;
  Change this instead of the home screen when we want to communicate a new update.

*/


import 'package:flutter/material.dart';


class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 5),
      child: Text(
        "welcome to the app! any news or updates will be posted here at the top of the homescreen",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "dubai",
          decoration: TextDecoration.none,
          color: Colors.white,
          fontSize: 20,
          height: 1,
        ),
      ),
    );
  }
}