import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ram/widgets/littlepost.dart';
import 'package:ram/widgets/post.dart';
import 'package:ram/models/paths.dart' as paths;

class PostList {

  bool little = false;
  static List<Post> list = [];
  static int nextPID = 0;

  PostList();

  PostList.little() {
    little = true;
  }

  int get length => list.length;
  bool get isEmpty => list.isEmpty;
  List<Post> get getList => list;

  Post at(index) {
    return list[index];
  }

  Future<void> getPosts(bool isAnon, String uid, int up) async {

    final response = await http.get(
      Uri.parse(paths.getPosts(nextPID.toString(), uid, up.toString()))
    );
    if (response.statusCode == 200) {
      try {
        List<dynamic> results = json.decode(response.body);
        for (var post in results) {
          if ( post['status'] ){
            post.remove('status');
            post['anon'] = isAnon;
            post['profilepicture'] = NetworkImage(paths.image(post['profilepicture']));
            post['image'] = NetworkImage(paths.image(post['image']));
            post['pid'] = int.parse(post['pid']);
            post['uid'] = int.parse(post['uid']);
            post['ups'] = int.parse(post['ups']);
            post['downs'] = int.parse(post['downs']);
            list.add(little ? LittlePost(post) : Post(post));
            nextPID = post['pid']-1;
          }
        }
      } catch (e) {
        Map<String, dynamic> result = json.decode(response.body);
        if (!result['status']){
          reset();
        }
      }
    }
  }

  void reset() {
    list = [];
    nextPID = 0;
  }

}