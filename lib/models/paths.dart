import 'package:flutter_dotenv/flutter_dotenv.dart';

String login(user, pass) {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/login.php?username="+user+"&password="+pass;
}

String signup() {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/signup.php";
}

String updateUsername() {
  return dotenv.env['API_PATH']!+"/ramdb_api/user/signup.php";
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

String getPost(pid) {
  return dotenv.env['API_PATH']!+"/ramdb_api/objects/getpost.php?pid="+pid;
}

String interact() {
  return dotenv.env['API_PATH']!+"/ramdb_api/post/interact.php";
}