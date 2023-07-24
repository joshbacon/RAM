import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paths.dart' as paths;

class User with ChangeNotifier{

  Map<String, dynamic> userData = {
    "uid":'0',
    "username": "null",
    "password": "null",
    "profile": const AssetImage('assets/defaultProfile.png'),
    "banner": const AssetImage('assets/defaultBanner.png')
  };

  User.asNull();

  User(Map<String, dynamic> userIn) {
    userData['uid'] = userIn['uid'];
    userData['username'] = userIn['username'];
  }

  String get uid => userData['uid'];
  String get username => userData['username'];
  dynamic get profile => userData['profile'];
  dynamic get banner => userData['banner'];

  Future<bool> saveData(password) async{
    
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', userData['username']);
    prefs.setString('password', password);

    return true;
  }

  Future<bool> logout() async{
    userData['uid'] = '0';
    userData['username'] = 'null';
    userData['password'] = 'null';
    userData['profile'] = const AssetImage('assets/defaultProfile.png');
    userData['banner'] = const AssetImage('assets/defaultBanner.png');
    saveData('null');
    return true;
  }

  Future<bool> login(usernameIn, passwordIn) async{
    final response = await http.get(
      Uri.parse(paths.login(usernameIn, passwordIn))
    );
    // figure out how to convert json thingy to an array (php to flutter array conversion)
    if (response.statusCode == 200){
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      userData['uid'] = data["uid"].toString();
      userData['username'] = data["username"].toString();
      userData['password'] = passwordIn;
      if (data['profile'] != null){
        userData['profile'] = NetworkImage(paths.image(data["profile"].toString()));
      }
      if (data['banner'] != null){
        userData['banner'] = NetworkImage(paths.image(data["banner"].toString()));
      }
      saveData(passwordIn);
      notifyListeners();
      return true;
    } else { return false; }
  }


  Future<bool> signup(usernameIn, passwordIn, emailIn) async {
    final response = await http.post(
      Uri.parse(paths.signup()),
      body: {
        'username': usernameIn,
        'password': passwordIn,
        'email': emailIn
      }
    );

    if (response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      userData['uid'] = data["uid"].toString();
      userData['username'] = data["username"].toString();
      userData['password'] = passwordIn;
      notifyListeners();
      saveData(passwordIn);
      return true;
    } else { return false; }
  }

  
  Future<bool> updateUsername(newUsername) async{
    final response = await http.put(
      Uri.parse(paths.updateUsername()),
      body: newUsername + ";" + userData['uid']
    );

    if (response.statusCode == 200){
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status']){
        userData['username'] = newUsername;
        saveData(userData['password']);
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
      var path = "http://192.168.2.14:80/../../ram_images/users/"+userData['uid']+"profile"+extension(image.path);
      print("path: " + path);
      userData['profile'] = Image.network(path).image;
      print("Image Uploaded");
      saveData(userData['password']);
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
      var path = "http://192.168.2.14:80/../../ram_images/users/"+userData['uid']+"banner"+extension(image.path);
      userData['banner'] = Image.network(path).image;
      print("Image Uploaded");
      saveData(userData['password']);
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
      //var path = "http://192.168.2.14:80/../../ram_images/users/"+userData['uid']+"post"+ DateTime.now().toString()+extension(image.path);
      print("Image Uploaded");
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