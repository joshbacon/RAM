import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './paths.dart' as paths;
import './security.dart';

class User with ChangeNotifier {

  Map<String, dynamic> userData = {
    "uid": "0",
    "username": "null",
    "joinedat": "null",
    "password": "null",
    "profile": const AssetImage('assets/defaultProfile.png'),
    "banner": const AssetImage('assets/defaultBanner.png')
  };

  User.asNull();

  User(Map<String, dynamic> userIn) {
    userData = userIn;
  }

  String get uid => userData['uid'];
  String get username => userData['username'];
  dynamic get profile => userData['profile'];
  dynamic get banner => userData['banner'];


  Future<User> getUserInfo(uid) async{
    final response = await http.get(
      Uri.parse(paths.getUser(uid.toString()))
    );

    print(response.body);
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 && data["status"]){
      userData['uid'] = data["uid"].toString();
      userData['username'] = data["username"].toString();
      userData['joinedat'] = data['joinedat'].toString();
      if (data['profile'] != null){
        userData['profile'] = NetworkImage(paths.image(data["profile"].toString()));
      }
      if (data['banner'] != null){
        userData['banner'] = NetworkImage(paths.image(data["banner"].toString()));
      }
      return User(userData);
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
      userData['uid'] = data["uid"].toString();
      print(userData['uid']);
      userData['username'] = data["username"].toString();
      userData['joinedat'] = data["joinedat"].toString();
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
      }
    );

    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200 && data['status']){
      userData['uid'] = data["uid"].toString();
      userData['joinedat'] = data['joinedat'].toString();
      userData['username'] = data["username"].toString();
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
    

  Future<bool> updateProfilePicture(image) async{

    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
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

    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
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
    
  // Copied from updateBannerPicture, need to adapt to upload a post
  Future<bool> uploadPost(image) async{

    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse(paths.acceptImage());

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length, filename: basename(image.path));

    request.files.add(multipartFile);
    request.fields['uid'] = userData['uid'];
    request.fields['state'] = 'post';
    request.fields['location'] = 'posts';
  
    var response = await request.send();
    if (response.statusCode == 200){
      return true;
    }
    return false;
  }
    
  // Copied from updateBannerPicture, need to adapt to upload a post
  Future<bool> uploadPostFromURL(image) async{
    final response = await http.post(
      Uri.parse(paths.acceptImageURL()),
      body: {
        'uid': userData['uid'],
        'image': image
      }
    );

    if (response.statusCode == 200){
      return true;
    } else { return false; }
  }
}