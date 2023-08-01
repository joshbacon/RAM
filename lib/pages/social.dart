

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {

  // TODO:
  // - add a social tab
  // -- allows to search for, add, and chat with other users
  // -- will need to update the database (have a chats table most likely, just watch a generic video for the principles)
  // - have a couple of that profile circle thing blurred out bouncing around in the background like an animation

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Stack(
      children: [

        // this is the actual interactable page
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          child: Text(
            'Social Tab',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "dubai",
              color: Color.fromRGBO(255, 163, 0, 1.0),
              fontSize: 32,
              height: 1,
            ),
          ),
        ),

        // this is the background
        Center(
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 200.0,
                sigmaY: 200.0,
              ),
              child: Container(
                width: w/4,
                height: w/4,
                color: const Color.fromRGBO(255, 163, 0, 0.69),
                child: const Icon(
                  Icons.person,
                  size: 64,
                  color: Color.fromRGBO(49, 49, 49, 1.0),
                ),
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}