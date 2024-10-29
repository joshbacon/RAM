import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/nav.dart';
import 'package:ram/pages/anonhome.dart';
import 'package:ram/models/user.dart';
import 'package:ram/widgets/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String errorMessage = "Login failed, check your username and password.";
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
      password.text = perfs.getString('password')!;
      login(true);
    }
  }

  void login(autoLogin) async {
    final response = await context.read<User>().login(username.text, password.text, autoLogin);

    if (context.mounted) {
      if (response[0] && context.read<User>().username != 'null'){
        showLoginErr = false;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NavPage()));
      } else {
        setState(() {
          errorMessage = response[1];
          showLoginErr = true;        
        });
      }
    }
  }

  void signup(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage(username.text, password.text)));
  }

  OutlineInputBorder borderTheme = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: const BorderSide(
      // color: Theme.of(context).colorScheme.primary,
      color: Color.fromRGBO(255, 163, 0, 1.0),
      width: 2.0,
    ),
  );
  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 100, 25, 0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: Image.asset('assets/icon.png'),
              ),
              // const Text(
              //   "RAM",
              //   style: TextStyle(
              //     fontFamily: "dubai",
              //     decoration: TextDecoration.none,
              //     color: Theme.of(context).colorScheme.primary,
              //     fontSize: 100,
              //     height: 1,
              //   ),
              // ),
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
              Text(
                "Create an account or sign in.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "dubai",
                  color: Theme.of(context).colorScheme.primary,
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
                  prefixIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary
                  ),
                  hintText: "username",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
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
                  prefixIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary
                  ),
                  hintText: "password",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: (){
                      if (username.text == '' || password.text == '') {
                        setState(() {
                          errorMessage = "username or password is empty";
                          showLoginErr = true;        
                        });
                      } else {
                        login(false);
                      }
                    },
                    child: const Text(
                      "sign in",
                      style: TextStyle(
                        fontFamily: "dubai",
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 25,
                      )
                    ),
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
                    child: const Text(
                      "sign up",
                      style: TextStyle(
                        fontFamily: "dubai",
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 25,
                      )
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Visibility(
                visible: showLoginErr,
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                child: const Text(
                  "browse anonymously",
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 24,
                  )
                ),
              ),
              Container(width: 275, height: 3, decoration:
                BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Theme.of(context).colorScheme.primary
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