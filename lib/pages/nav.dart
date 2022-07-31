//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/home.dart';
import 'package:ram/pages/profile.dart';
import 'package:ram/pages/upload.dart';
import 'package:ram/models/user.dart';

class NavPage extends StatefulWidget {

  //User userIn;
  NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  
  //User user = User.asNull();
  int pageIndex = 0;

  //@override
  //void initState() {
  //  super.initState();
  //  user = widget.userIn;
  //}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var profile = context.read<User>().profile;
    var banner = context.read<User>().banner;
    if (profile.runtimeType is! AssetImage){
      precacheImage(context.read<User>().profile, context);
    }
    if ( banner.runtimeType is! AssetImage ){
      precacheImage(context.read<User>().banner, context);
    }
  }

  late var pages = [
    const HomePage(), const UploadPage(), const ProfilePage()
  ];


  void onTap(int index){
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return //ChangeNotifierProvider(
      //builder: (context) => User(),
      //create: (BuildContext context) {  },
      //create: (_) => user,
      //child:
      Scaffold(
        backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(91, 91, 91, 1.0),
          unselectedItemColor: const Color.fromRGBO(255, 163, 0, 1.0),
          selectedItemColor: Colors.white,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          elevation: 1,
          iconSize: 35,
          items: const [
            BottomNavigationBarItem(
              label: "home",
              icon: Icon(Icons.home)
            ),
            BottomNavigationBarItem(
              label: "upload",
              icon: Icon(Icons.add),
            ),
            BottomNavigationBarItem(
              label: "profile",
              icon: Icon(Icons.account_circle_outlined),
            ),
          ],
        ),
     // ),
    );
  }
}
