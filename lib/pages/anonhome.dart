import 'package:flutter/material.dart';
import 'package:ram/pages/login.dart';

class AnonPage extends StatefulWidget {
  const AnonPage({Key? key}) : super(key: key);

  @override
  State<AnonPage> createState() => _AnonPageState();
}

class _AnonPageState extends State<AnonPage> {

  void onTap(index) {
    if (index == 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      // back to top
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      body: Column(
        children: const [
          Text("AnonPage", style: TextStyle(
              fontFamily: "dubai",
              decoration: TextDecoration.none,
              color: Colors.white,
              fontSize: 25,
            ),),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(91, 91, 91, 1.0),
        unselectedItemColor: const Color.fromRGBO(255, 163, 0, 1.0),
        selectedItemColor: const Color.fromRGBO(255, 163, 0, 1.0),
        selectedFontSize: 13,
        unselectedFontSize: 13,
        elevation: 1,
        iconSize: 35,
        items: const [
          BottomNavigationBarItem(
            label: "login",
            icon: Icon(Icons.logout_outlined)
          ),
          BottomNavigationBarItem(
            label: "back to top",
            icon: Icon(Icons.upgrade_outlined)
          ),
        ]
      ),
    );
  }
}