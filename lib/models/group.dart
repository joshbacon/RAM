import 'dart:convert';
import 'package:ram/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ram/models/paths.dart' as paths;

class Group {

  static int id = 0;
  static String name = "";

  const Group.personal();

  Group(int inID, String inName) {
    id = inID;
    name = inName;
  }

  int get getID => id;
  String get getName => name;

  Future<List<User>> getParticipants(String uid) async {
    final response = await http.get(
      Uri.parse(paths.getParticipants(uid, id.toString()))
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> results = json.decode(response.body);
        List<User> participants = [];
        for (var user in results) {
          if ( user['status'] ){
            user.remove('status');
            user['uid'] == user['uid'].toString();
            user['username'] = user["username"].toString();
            user['bio'] = user["bio"].toString();
            user['joinedat'] = DateTime.parse(user["joinedat"]).toLocal();
            user['ups'] = user['ups'] == 0 ? 1 : user['ups'];
            user['downs'] = user['downs'] == 0 ? 1 : user['downs'];
            user['profile'] = user['profile'] != null ? NetworkImage(paths.image(user["profile"].toString())) : const AssetImage('assets/defaultProfile.png');
            user['banner'] = user['banner'] != null ? NetworkImage(paths.image(user["banner"].toString())) : const AssetImage('assets/defaultBanner.png');
            user['isFriend'] = user['isFriend'] == 1;
            participants.add(User(user));
          }
        }
        return participants;
      } catch (e) {
        // Map<String, dynamic> result = json.decode(response.body);
        return [];
      }
    }
    return [];
  }

}