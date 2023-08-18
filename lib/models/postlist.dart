import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ram/widgets/littlepost.dart';
import 'package:ram/widgets/post.dart';
import '../models/paths.dart' as paths;

class PostList {

  bool little = false;
  static List<Post> list = [];
  static int nextPID = 0;

  PostList();

  PostList.little() {
    little = true;
  }

  int length() {
    return list.length;
  }

  bool isEmpty() {
    return list.isEmpty;
  }

  Post at(index) {
    return list[index];
  }

  List<Post> getList() {
    return list;
  }

  Future<void> getPosts(bool isAnon, String uid, int up) async {

    final response = await http.get(
      Uri.parse(paths.getPost(nextPID.toString(), uid, up.toString()))
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
    // Limit the list to 25 posts?
    // this might do a weird scrolling thing cause the list builder doesn't account for it
    // if (length() > 25) {
    //   list.removeRange(0, length()-25);
    // }
  }

  Future<void> reset() async {
    list = [];
    nextPID = 0;
  }

}