import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:ram/models/group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ram/models/paths.dart' as paths;
import 'package:ram/models/security.dart';

class User with ChangeNotifier {

  Map<String, dynamic> userData = {
    "uid": "0",
    "username": "null",
    "bio": null,
    "joinedat": DateTime.now().toLocal(),
    "ups": 1,
    "downs": 1,
    "password": "null",
    "profile": const AssetImage('assets/defaultProfile.png'),
    "banner": const AssetImage('assets/defaultBanner.png')
  };

  User.asNull();

  User(Map<String, dynamic> userIn) {
    userData = userIn;
  }

  String get uid => userData['uid'].toString();
  String get username => userData['username'];
  String? get bio => userData['bio'];
  DateTime get joinedat => userData['joinedat'];
  dynamic get profile => userData['profile'];
  dynamic get banner => userData['banner'];
  dynamic get ups => userData['ups'];
  dynamic get downs => userData['downs'];
  bool? get isFriend => userData['isFriend'];

  Future<User> getUserInfo(uid) async{
    final response = await http.get(
      Uri.parse(paths.getUser(uid.toString(), userData['uid']))
    );

    Map<String, dynamic> info = json.decode(response.body);
    if (response.statusCode == 200 && info["status"]){
      Map<String, dynamic> userInfo = {};
      userInfo['uid'] = info["uid"].toString();
      userInfo['username'] = info["username"].toString();
      userInfo['bio'] = info["bio"].toString();
      userInfo['joinedat'] = DateTime.parse(info['joinedat']).toLocal();
      userInfo['ups'] = info['ups'] == 0 ? 1 : int.parse(info['ups']);
      userInfo['downs'] = info['downs'] == 0 ? 1 : int.parse(info['downs']);
      if (info['profile'] != null){
        userInfo['profile'] = NetworkImage(paths.image(info["profile"].toString()));
      } else {
        userInfo['profile'] = const AssetImage('assets/defaultProfile.png');
      }
      if (info['banner'] != null){
        userInfo['banner'] = NetworkImage(paths.image(info["banner"].toString()));
      } else {
        userInfo['banner'] = const AssetImage('assets/defaultBanner.png');
      }
      if (info['isFriend'] != null) {
        userInfo['isFriend'] = info['isFriend'] == '1';
      } else {
        userInfo['isFriend'] = null;
      }
      return User(userInfo);
    }
    return User.asNull();
  }

  Future<bool> saveData() async{
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', userData['username']);
    prefs.setString('password', userData['password']);

    return true;
  }

  Future<bool> logout() async{
    userData['uid'] = '0';
    userData['username'] = 'null';
    userData['password'] = 'null';
    userData['bio'] = 'null';
    userData['joinedat'] = DateTime.now().toLocal();
    userData['ups'] = 0;
    userData['downs'] = 0;
    userData['profile'] = const AssetImage('assets/defaultProfile.png');
    userData['banner'] = const AssetImage('assets/defaultBanner.png');
    saveData();
    return true;
  }

  Future<List<dynamic>> login(usernameIn, passwordIn, autoLogin) async{

    String encrypted = autoLogin ? passwordIn : EncryptData.encryptAES(passwordIn);

    final response = await http.get(
      Uri.parse(paths.login(usernameIn, encrypted))
    );
    Map<String, dynamic> data = json.decode(response.body.trim());
    if (response.statusCode == 200){
      data['ups'] = int.parse(data['ups']);
      data['downs'] = int.parse(data['downs']);
      userData['uid'] = data["uid"].toString();
      userData['username'] = data["username"].toString();
      userData['bio'] = data["bio"].toString();
      userData['joinedat'] = DateTime.parse(data["joinedat"]).toLocal();
      userData['ups'] = data['ups'] == 0 ? 1 : data['ups'];
      userData['downs'] = data['downs'] == 0 ? 1 : data['downs'];
      userData['password'] = encrypted;
      if (data['profile'] != null){
        userData['profile'] = NetworkImage(paths.image(data["profile"].toString()));
      }
      if (data['banner'] != null){
        userData['banner'] = NetworkImage(paths.image(data["banner"].toString()));
      }
      notifyListeners();
      saveData();
    }
    return [data['status'], data['message']];
  }


  Future<List<dynamic>> signup(usernameIn, passwordIn, emailIn) async {
    passwordIn = EncryptData.encryptAES(passwordIn);
    final response = await http.post(
      Uri.parse(paths.signup()),
      body: {
        'username': usernameIn,
        'password': passwordIn,
        'email': emailIn
      },
    );

    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 && data['status']){
      userData['uid'] = data["uid"].toString();
      userData['username'] = data["username"].toString();
      userData['bio'] = data["bio"].toString();
      userData['joinedat'] = DateTime.parse(data['joinedat']).toLocal();
      userData['ups'] = data['ups'] == 0 ? 1 : int.parse(data['ups']);
      userData['downs'] = data['downs'] == 0 ? 1 : int.parse(data['downs']);
      userData['password'] = passwordIn;
      notifyListeners();
      saveData();
    }
    return [data['status'], data['message']];
  }

  
  Future<bool> updateUsername(newUsername) async{
    final response = await http.put(
      Uri.parse(paths.updateUsername()),
      body: newUsername + ";" + userData['uid']
    );

    if (response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status']){
        userData['username'] = newUsername;
        saveData();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  
  Future<bool> updateBio(newBio) async{
    final response = await http.put(
      Uri.parse(paths.updateBio()),
      body: newBio + ";" + userData['uid']
    );

    if (response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status']){
        userData['bio'] = newBio;
        saveData();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<List<User>> getFriends() async {
    final response = await http.get(
      Uri.parse(paths.getFriends(userData['uid']))
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> results = json.decode(response.body);
        List<User> friends = [];
        for (var user in results) {
          if ( user['status'] ){
            user.remove('status');
            user['uid'] == user['uid'].toString();
            user['username'] = user["username"].toString();
            user['bio'] = user["bio"].toString();
            user['joinedat'] = DateTime.parse(user["joinedat"]).toLocal();
            user['ups'] = user['ups'] == 0 ? 1 : int.parse(user['ups']);
            user['downs'] = user['downs'] == 0 ? 1 : int.parse(user['downs']);
            user['profile'] = user['profile'] != null ? NetworkImage(paths.image(user["profile"].toString())) : const AssetImage('assets/defaultProfile.png');
            user['banner'] = user['banner'] != null ? NetworkImage(paths.image(user["banner"].toString())) : const AssetImage('assets/defaultBanner.png');
            user['isFriend'] = user['isFriend'] == '1';
            friends.add(User(user));
          }
        }
        return friends;
      } catch (e) {
        // Map<String, dynamic> result = json.decode(response.body);
        return [];
      }
    }
    return [];
  }

  Future<List<User>> getRequests() async {
    final response = await http.get(
      Uri.parse(paths.getRequests(userData['uid']))
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> results = json.decode(response.body);
        List<User> friends = [];
        for (var user in results) {
          if ( user['status'] ){
            user.remove('status');
            user['uid'] == user['uid'].toString();
            user['username'] = user["username"].toString();
            user['bio'] = user["bio"].toString();
            user['joinedat'] = DateTime.parse(user["joinedat"]).toLocal();
            user['ups'] = user['ups'] == 0 ? 1 : int.parse(user['ups']);
            user['downs'] = user['downs'] == 0 ? 1 : int.parse(user['downs']);
            user['profile'] = user['profile'] != null ? NetworkImage(paths.image(user["profile"].toString())) : const AssetImage('assets/defaultProfile.png');
            user['banner'] = user['banner'] != null ? NetworkImage(paths.image(user["banner"].toString())) : const AssetImage('assets/defaultBanner.png');
            user['isFriend'] = user['isFriend'] == '1';
            friends.add(User(user));
          }
        }
        return friends;
      } catch (e) {
        // Map<String, dynamic> result = json.decode(response.body);
        return [];
      }
    }
    return [];
  }

  Future<List<Group>> getGroups() async {
    final response = await http.get(
      Uri.parse(paths.getGroups(userData['uid']))
    );

    if (response.statusCode == 200) {
      try {
        List<dynamic> results = json.decode(response.body);
        List<Group> groups = [];
        for (var group in results) {
          if ( group['status'] ){
            groups.add(Group(int.parse(group['gid']), group["name"]));
          }
        }
        return groups;
      } catch (e) {
        // Map<String, dynamic> result = json.decode(response.body);
        return [];
      }
    }
    return [];
  }

  Future<bool> addFriend(friend) async {
    final response = await http.post(
      Uri.parse(paths.addFriend()),
      body: {
        'self': userData['uid'].toString(),
        'friend': friend.toString()
      },
    );

    if (response.statusCode == 200 && json.decode(response.body)['accepted']) {
      userData['isFriend'] = true;
      return true;
    }
    return false;
  }

  Future<bool> sendMessage(to, group, message) async {
    final response = await http.post(
      Uri.parse(paths.sendMessage()),
      body: {
        'sender': userData['uid'].toString(),
        'receiver': to.toString(),
        'group': group.toString(),
        'message': message
      },
    );

    return response.statusCode == 200 && json.decode(response.body)['status'];
  }
    

  // TODO: sometimes this and updateBannerPicture don't update on the screen,
  //        even though they upload the image to the server
  Future<bool> updateProfilePicture(image) async{

    var stream = http.ByteStream(image.openRead());
    stream.cast();
    var length = await image.length();
    var uri = Uri.parse(paths.acceptImage());

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length, filename: basename(image.path));

    request.files.add(multipartFile);
    request.fields['uid'] = userData['uid'];
    request.fields['state'] = 'profile';
    request.fields['location'] = 'users';
  
    var response = await request.send();
    if (response.statusCode == 200){
      String path = paths.profileImage(userData['uid'], extension(image.path));
      userData['profile'] = Image.network(path).image;
      notifyListeners();
      return true;
    }
    return false;
  }
    

  Future<bool> updateBannerPicture(image) async{

    var stream = http.ByteStream(image.openRead());
    stream.cast();
    var length = await image.length();
    var uri = Uri.parse(paths.acceptImage());

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length, filename: basename(image.path));

    request.files.add(multipartFile);
    request.fields['uid'] = userData['uid'];
    request.fields['state'] = 'banner';
    request.fields['location'] = 'users';
  
    var response = await request.send();
    if (response.statusCode == 200){
      String path = paths.bannerImage(userData['uid'], extension(image.path));
      userData['banner'] = Image.network(path).image;
      notifyListeners();
      return true;
    }
    return false;
  }
  
  
  Future<bool> uploadPost(image) async{

    var stream = http.ByteStream(image.openRead());
    stream.cast();
    var length = await image.length();
    var uri = Uri.parse(paths.acceptImage());

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length, filename: basename(image.path));

    request.files.add(multipartFile);
    request.fields['uid'] = userData['uid'];
    request.fields['state'] = 'post';
    request.fields['location'] = 'posts';
  
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<bool> uploadPostFromURL(image) async{
    final response = await http.post(
      Uri.parse(paths.acceptImageURL()),
      body: {
        'uid': userData['uid'],
        'image': image,
        'state': 'post'
      }
    );

    return response.statusCode == 200;
  }
}