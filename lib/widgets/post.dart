import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/postlist.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ram/models/user.dart';
import "package:async/async.dart";
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paths.dart' as paths;


class Post extends StatefulWidget {

  const Post(this.data, {Key? key}) : super(key: key);
  
  final Map<String, dynamic> data;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  // TODO:
  // - have the username or profile pic (the top bar basically) navigate to users page
  // -- will need a view style of the profile page (just hide the settings button actually)
  // --- change the settings button to an add or chat button or something
  // - double check the interactions are working

  Future<bool> interact(uid, up) async {
    
    var uri = Uri.parse(paths.interact());
    var request = http.MultipartRequest("POST", uri);

    request.fields['pid'] = widget.data['pid'].toString();
    request.fields['uid'] = uid;
    request.fields['up'] = up;
  
    var response = await request.send();
    //return response.statusCode == 200;
    if( response.statusCode == 200 ){
      print('worked');
      return true;
    }
    print('!worked');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashColor: const Color(0x00000000),
                  icon: CircleAvatar(
                    radius: min(64, w/6),
                    backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
                    backgroundImage: widget.data['profilepicture'],
                  ),
                  onPressed: () {}, // goto users profile page
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.data['username'],
                  style: const TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox( height: 10, ),
        Image(
          image: widget.data['image'],
          fit: BoxFit.fitWidth
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: !widget.data['anon'],
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Image( image: AssetImage("assets/dPlus.png"), width: 40, height: 40,),
                  onPressed: () {
                    //setState(() {
                      widget.data['ups'] += 1;
                      interact(context.read<User>().uid, true);
                      // make a DB call to update post
                    //});
                  },
                ),
              ),
              const SizedBox( width: 15, height: 25 ),
              Container(
                width: (widget.data['ups'] / (widget.data['ups'] + widget.data['downs']))*(w-(widget.data['anon']?60:156)),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: const Color.fromRGBO(255, 163, 0, 1.0)
                ),
              ),
              Container(
                // width: (widget.data['downs'] / (widget.data['ups'] + widget.data['downs']))*(w-156),
                width: (widget.data['downs'] / (widget.data['ups'] + widget.data['downs']))*(w-(widget.data['anon']?60:156)),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: const Color.fromRGBO(170 , 0, 0, 1.0)
                ),
              ),
              const SizedBox( width: 15, height: 25 ),
              Visibility(
                visible: !widget.data['anon'],
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Image( image: AssetImage("assets/dMinusRed.png"), width: 40, height: 40,),
                  onPressed: () {
                    //setState(() {
                      widget.data['downs'] += 1;
                      interact(context.read<User>().uid, false);
                      // make a DB call to update post
                    //});
                  },
                ),
              ),
            ],
          )
        ),
        Center(
          child: Container(width: w, height: 3, decoration:
            BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: const Color.fromARGB(26, 0, 0, 0)
            ),
          ),
        ),
        const SizedBox( height: 10 ),
      ],
    );
  }
}
