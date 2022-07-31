import 'package:flutter/material.dart';
import 'package:ram/models/postlist.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Post extends StatefulWidget {

  final Map<String, dynamic> data;

  const Post(this.data, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Post> createState() => _PostState(data);
}

class _PostState extends State<Post> {

  Map<String, dynamic> data;// = {
  //  'pid': 0,
  //  'uid': '1',
  //  'ups': 0,
  //  'downs': 0,
  //  'image': const AssetImage('assets/postNotFoundImage.jpg')
  //};
  
  _PostState(this.data);

  //@override
  //void initState() async {
  //  super.initState();
  //  final response = await http.get(
  //    Uri.parse("http://192.168.2.17:80/ramdb_api/user/getpost.php?pid="+data['pid'].toString())
  //  );
  //  // make get call here and set data
  //  if (response.statusCode == 200){
  //    data = json.decode(response.body);
  //    data['image'] = Image.network(data['image']).image;
  //  }
  //}

  @override
  Widget build(BuildContext context) {
    return //Expanded(
      //child:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  splashColor: const Color(0x00000000),
                  icon: const Image( image: AssetImage("assets/defaultProfile.png"), width: 64, height: 64,),
                  onPressed: () {}, // goto users profile page
                ),
                TextButton(
                  child: const Text( "Username",
                    style: TextStyle(
                      fontFamily: "dubai",
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 30,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {}, // goto users profile page
                )
              ],
            ),
          ),
          const SizedBox( height: 10, ),
          Image(
            image: data['image'],
            fit: BoxFit.fitWidth
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Image( image: AssetImage("assets/dPlus.png"), width: 64, height: 64,),
                  onPressed: () {
                    setState(() {
                      data['ups'] += 1;
                      // make a DB call to update post
                    });
                  },
                ),
                const SizedBox( width: 15, ),
                Container(width: (data['ups'] / (data['ups'] + data['downs']))*250, height: 3, decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: const Color.fromRGBO(255, 163, 0, 1.0)
                  ),
                ),
                Container(width: (data['downs'] / (data['ups'] + data['downs']))*250, height: 3, decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                   color: const Color.fromRGBO(170 , 0, 0, 1.0)
                 ),
                ),
                const SizedBox( width: 15, ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Image( image: AssetImage("assets/dMinusRed.png"), width: 64, height: 64,),
                  onPressed: () {
                    setState(() {
                      data['downs'] += 1;
                      // make a DB call to update post
                    });
                  },
                ),
              ],
            )
          )
        ],
      //),
    );
  }
}