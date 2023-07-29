import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/nav.dart';
import 'package:ram/pages/anonhome.dart';
import 'package:ram/models/user.dart';
import 'package:ram/widgets/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/security.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  //User user = User.asNull();
  bool showLoginErr = false;

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    var perfs = await SharedPreferences.getInstance();
    if( perfs.containsKey('username') && perfs.containsKey('password') &&
        perfs.getString('username') != 'null' && perfs.getString('password') != 'null'){
      username.text = perfs.getString('username')!;
      password.text = EncryptData.decryptAES(perfs.getString('password')!);
      login();
    }
  }

  void login() async {
    final response = await context.read<User>().login(username.text, password.text);

    if (response){
      if (context.read<User>().username != 'null'){
        showLoginErr = false;
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavPage()));
      } else {
        showLoginErr = true;
      }
    } else {
      showLoginErr = true;
    }
  }

  void signup(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage(username.text, password.text)));
  }


  OutlineInputBorder borderTheme = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: const BorderSide(
      color: Color.fromRGBO(255, 163, 0, 1.0),
      width: 2.0,
    )
  );

  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 100, 25, 0),
            child: Column(children: [
              const Text(
                "RAM",
                style: TextStyle(
                  fontFamily: "dubai",
                  decoration: TextDecoration.none,
                  color: Color.fromRGBO(255, 163, 0, 1.0),
                  fontSize: 100,
                  height: 1,
                ),
              ),
              const Text(
                "Random Access Memes",
                style: TextStyle(
                  fontFamily: "dubai",
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 28,
                  height: 1,
                ),
              ),
              const Spacer(flex: 7),
              const Text(
                "Create an account or sign in.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "dubai",
                  color: Color.fromRGBO(255, 163, 0, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(flex: 1),
              TextFormField(
                controller: username,
                style: const TextStyle(
                  fontFamily: "dubai",
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(91, 91, 91, 1.0),
                  errorBorder: borderTheme,
                  focusedBorder: borderTheme,
                  focusedErrorBorder: borderTheme,
                  disabledBorder: borderTheme,
                  enabledBorder: borderTheme,
                  border: borderTheme,
                  prefixIcon: const Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(255, 163, 0, 1.0)),
                  hintText: "username",
                  hintStyle: const TextStyle(
                    fontFamily: "dubai",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              TextFormField(
                controller: password,
                obscureText: true,
                style: const TextStyle(
                  fontFamily: "dubai",
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(91, 91, 91, 1.0),
                  errorBorder: borderTheme,
                  focusedBorder: borderTheme,
                  focusedErrorBorder: borderTheme,
                  disabledBorder: borderTheme,
                  enabledBorder: borderTheme,
                  border: borderTheme,
                  prefixIcon: const Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(255, 163, 0, 1.0)),
                  hintText: "password",
                  hintStyle: const TextStyle(
                    fontFamily: "dubai",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: (){
                      if (username.text == '' || password.text == '') {
                        // show some error message
                        print("username or password is empty");
                      } else { login(); }
                    },
                    child: const Text("sign in", style: TextStyle(
                      fontFamily: "dubai",
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 25,
                    )),
                  ),
                  Container(width: 3, height: 30, decoration:
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Colors.white
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      signup();
                    },
                    child: const Text("sign up", style: TextStyle(
                      fontFamily: "dubai",
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 25,
                    )),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Visibility(
                visible: showLoginErr,
                child: const Text(
                  "Login failed, check your username and password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "dubai",
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ),
              const Spacer(flex: 6),
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AnonPage()));
                },
                child: const Text("browse anonymously", style: TextStyle(
                  fontFamily: "dubai",
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 24,
                )),
              ),
              Container(width: 275, height: 3, decoration:
                BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: const Color.fromRGBO(255, 163, 0, 1.0)
                ),
              ),
              const Spacer(flex: 2),
            ],
            ),
          ),
        ),
      )
    );
  }
}