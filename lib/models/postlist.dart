import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';




class PostList {

  List<Map<String, dynamic>> list = [];

  late int nextPID;

  List get data => list;
  int get len => list.length;

  PostList() {
    //somehow query the most recent pid, set to nextPIDinstead of below number
    //nextPID = 5;
    
    getNewestPost();
    // make get call h
    //list.removeAt(0);
  }

  Future<bool> getNewestPost() async{
    final response = await http.get(
      Uri.parse("http://192.168.2.17:80/ramdb_api/objects/getpost.php?pid=0")
    );
    // make get call here and set data
    if (response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      data.remove('status');
      data['image'] = NetworkImage("http://192.168.2.17:80/"+data['image']);
      list = [data];
      //list.add(data);
      nextPID = data['pid'] - 1;
      //addXPosts(1);
      return true;
    } else {
      nextPID = 8;
      return false;
    }
  }

  Future<bool> getPost() async{
    final response = await http.get(
      Uri.parse("http://192.168.2.17:80/ramdb_api/objects/getpost.php?pid="+nextPID.toString())
    );
    // make get call here and set data
    if (response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      if ( data['status'] ){
        data.remove('status');
        data['image'] = NetworkImage("http://192.168.2.17:80/"+data['image']);
        list.add(data);
        nextPID -= 1;
        return true;
      }
    }
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