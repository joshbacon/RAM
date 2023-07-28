import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/nav.dart';
import 'package:ram/pages/login.dart';
import 'package:ram/models/user.dart';


class SignupPage extends StatefulWidget {
  final String usernameIn;
  final String passwordIn;

  const SignupPage(this.usernameIn, this.passwordIn, {Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController username = TextEditingController(text: widget.usernameIn);
  late final TextEditingController password = TextEditingController(text: widget.passwordIn);
  final TextEditingController email = TextEditingController();

  //User user = User.asNull();
  
  final OutlineInputBorder borderTheme = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: const BorderSide(
      color: Color.fromRGBO(255, 163, 0, 1.0),
      width: 2.0,
    )
  );

  
  void signup() async {
    final result = await context.read<User>().signup(username.text, password.text, email.text);
    if (result) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NavPage()));
    } else {
      // show some error message
      print("uid == 0, username == ''");
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 163, 0, 1.0),
        foregroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
        child: const Icon(Icons.check_outlined, size: 36,),
        onPressed: () { signup(); }
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 100, 25, 0),
            child: Column(
              children: [
                const Text("RAM", style: TextStyle(
                  fontFamily: "dubai",
                  decoration: TextDecoration.none,
                  color: Color.fromRGBO(255, 163, 0, 1.0),
                  fontSize: 100,
                  height: 1,
                ),),
                const Text("create an account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "dubai",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                const Spacer(flex: 3),
                const Text("username",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 25,
                  )
                ),
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
                  ),
                ),
                const Spacer(flex: 1),
                const Text("password",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 25,
                  )
                ),
                TextFormField(
                  controller: password,
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
                  ),
                ),
                const Spacer(flex: 1),
                const Text("email",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 25,
                  )
                ),
                TextFormField(
                  controller: email,
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
                  ),
                ),
                const Spacer(flex: 1),
                const Text( "idc email can be fake but you won't be able to recover your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "dubai",
                    color: Color.fromRGBO(255, 163, 0, 1.0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(flex: 12),
              ],
            )
          ),
        ),
      )
    );
  }
}