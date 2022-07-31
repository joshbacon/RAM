import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';




class PostList {

  List<Map<String, dynamic>> list = [{
    'pid': 0,
    'uid': '1',
    'ups': 1,
    'downs': 1,
    'image': const AssetImage('assets/postNotFoundImage.jpg'),
  }];

  int nextPID = 3;

  List get data => list;
  int get len => list.length;

  PostList() {
    //somehow query the most recent pid, set to nextPIDinstead of below number
    nextPID = 5;
    list.removeAt(0);
  }

  Future<bool> getPost() async{
      print('in get post');
    final response = await http.get(
      Uri.parse("http://192.168.2.17:80/ramdb_api/objects/getpost.php?pid="+nextPID.toString())
    );
    // make get call here and set data
    if (response.statusCode == 200){
      print('decoding...');
      Map<String, dynamic> data = json.decode(response.body);
        print('done decoding');
      if ( data['status'] ){
        print('status checks');
        data.remove('status');
        data['image'] = NetworkImage("http://192.168.2.17:80/"+data['image']);
        list.add(data);
        nextPID -= 1;
      print('returning true - ' + list.length.toString());
        return true;
      }
    }
      print('returning false');
    return false;
  }

  Future<void> addXPosts(int x) async {
    for (int i = 0; i < x; i++){
      getPost();
    }
  }

  Future<void> removeXPosts(int x) async {
    for (int i = 0; i < x; i++){
      list.removeAt(1);
    }
  }

}