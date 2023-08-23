import 'package:flutter_dotenv/flutter_dotenv.dart';

String login(user, pass) {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/login.php?username="+user+"&password="+pass;
}

String signup() {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/signup.php";
}

String updateUsername() {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/updateusername.php";
}

String updateBio() {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/updatebio.php";
}

String addFriend() {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/addfriend.php";
}

String acceptImage() {
  return dotenv.env['API_PATH']!+"/ramdb_api/post/acceptimage.php";
}

String acceptImageURL() {
  return dotenv.env['API_PATH']!+"/ramdb_api/post/acceptimageurl.php";
}

String image(value) {
  return dotenv.env['API_PATH']!+"/"+value;
}

String getUser(uid) {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/getuserinfo.php?uid="+uid;
}

String searchUsers(query) {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/searchusers.php?query="+query;
}

String getFriends(uid) {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/getfriends.php?uid="+uid;
}

String getPost(pid, uid, up) {
  return dotenv.env['API_PATH']!+"/ramdb_api/post/getpost.php?pid="+pid+"&uid="+uid+"&up="+up;
}

String interact() {
  return dotenv.env['API_PATH']!+"/ramdb_api/post/interact.php";
}

String checkInteraction(uid, pid) {
  return dotenv.env['API_PATH']!+"/ramdb_api/post/getinteracts.php?pid="+pid+"&uid="+uid;
}

String profileImage(uid, exten) {
  return dotenv.env['API_PATH']!+"/ram_images/users/"+uid+"profile"+exten;
}

String bannerImage(uid, exten) {
  return dotenv.env['API_PATH']!+"/ram_images/users/"+uid+"banner"+exten;
}