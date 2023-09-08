import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/nav.dart';
import 'package:ram/models/user.dart';


class SignupPage extends StatefulWidget {
  final String usernameIn;
  final String passwordIn;

  const SignupPage(this.usernameIn, this.passwordIn, {Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  String message = "create an account.";
  bool isError = false;

  late final TextEditingController username = TextEditingController(text: widget.usernameIn);
  late final TextEditingController password = TextEditingController(text: widget.passwordIn);
  final TextEditingController email = TextEditingController();
  
  final OutlineInputBorder borderTheme = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: const BorderSide(
      // color: Theme.of(context).colorScheme.primary,
      color: Color.fromRGBO(255, 163, 0, 1.0),
      width: 2.0,
    )
  );

  
  void signup() async {
    final result = await context.read<User>().signup(username.text, password.text, email.text);
    if (result[0]) {
      setState(() {
        isError = false;
        message = result[1];
      });
      if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => const NavPage()));
    } else {
      setState(() {
        isError = true;
        message = result[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.background,
        child: const Icon(Icons.check_outlined, size: 36,),
        onPressed: () {
          signup();
        }
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 100, 25, 0),
            child: Column(
              children: [
                Text(
                  "RAM",
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 100,
                    height: 1,
                  ),
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "dubai",
                    color: isError ?  Colors.red: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                const Spacer(flex: 3),
                const Text(
                  "username",
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
                    fillColor: Theme.of(context).colorScheme.surface,
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
                  ),
                ),
                const Spacer(flex: 1),
                const Text(
                  "password",
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
                    fillColor: Theme.of(context).colorScheme.surface,
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
                    fillColor: Theme.of(context).colorScheme.surface,
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
                  ),
                ),
                const Spacer(flex: 1),
                Text(
                  "idc email can be fake but you won't be able to recover your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "dubai",
                    color: Theme.of(context).colorScheme.primary,
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