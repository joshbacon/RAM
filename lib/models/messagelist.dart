import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ram/models/message.dart';
import 'package:ram/models/paths.dart' as paths;

class MessageList {

  static List<Message> list = [];
  static int nextMID = 0;

  MessageList();

  int get length => list.length;
  bool get isEmpty => list.isEmpty;

  Message at(index) {
    return list[index];
  }

  void addMessage(Message newMsg) {
    list.add(newMsg);
  }

  void removeMessage() {
    list.removeLast();
  }

  Future<void> getMessages(String uid, String friend, String groupID) async {

    final response = await http.get(
      Uri.parse(paths.getMessages(nextMID.toString(), uid, friend, groupID))
    );
    if (response.statusCode == 200) {
      try {
        List<dynamic> results = json.decode(response.body);
        for (var msg in results) {
          if ( msg['status'] ){
            list.add(Message(
              msg['message'],
              msg['senderID'].toString(),
              msg['senderName'].toString(),
              msg['profilepicture'] != null ? NetworkImage(paths.image(msg['profilepicture'])) : const AssetImage('assets/defaultProfile.png')
            ));
            nextMID = int.parse(msg['mid'])+1;
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
    nextMID = 0;
  }

}