import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/home.dart';
import 'package:ram/pages/upload.dart';
import 'package:ram/pages/social.dart';
import 'package:ram/pages/profile.dart';
import 'package:ram/models/user.dart';

class NavPage extends StatefulWidget {

  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  
  int pageIndex = 0;

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
    const HomePage(), const UploadPage(), const SocialPage(), ProfilePage(context.watch<User>())
  ];


  void onTap(int index){
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13,
        unselectedFontSize: 13,
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
            label: "social",
            icon: Icon(Icons.social_distance_rounded),
          ),
          BottomNavigationBarItem(
            label: "profile",
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
    );
  }
}
