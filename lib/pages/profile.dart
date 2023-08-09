import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/widgets/post.dart';
import 'package:ram/widgets/sidemenu.dart';
import 'package:ram/models/user.dart';
import '../models/paths.dart' as paths;


class ProfilePage extends StatefulWidget {

  const ProfilePage(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // TODO:
  // - make category buttons functional
  // - grab posts based on selected category
  // - show in a weird cool style (think pinterest)
  // - fix the alignment on the racket logo
  // - make it username button drop down and show a bio and date joined

  var totalUps = 1;
  var totalDowns = 1;
  int category = 0;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void openDrawer() {
    setState(() {
      _drawerKey.currentState?.openDrawer();
    });
  }

  void setCategory(int index) {
    // at some point look into caching images
    if (index == 0) {
      // query for the users posts
      category = index;
    } else if (index == 1) {
      // query for posts liked by the user
      category = index;
    } else if (index == 2) {
      // query for posts disliked by the user
      category = index;
    }
  } 

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _drawerKey,
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      drawer: const SideMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Column(
        children: [
          Visibility(
            visible: context.watch<User>().uid != widget.user.uid,
            child: FloatingActionButton(
              heroTag: "backBtn",
              backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
              foregroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 48,
                color: Color.fromRGBO(255, 163, 0, 1.0)
              ),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ),
          Visibility(
            visible: context.watch<User>().uid != widget.user.uid,
            child:  FloatingActionButton(
              heroTag: "addBtn",
              backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
              foregroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
              child: const Icon(
                Icons.group_add_outlined,
                size: 48,
                color: Color.fromRGBO(255, 163, 0, 1.0)
              ),
              onPressed: () {
                //send a friend request
              }
            ),
          ),
          Visibility(
            visible: context.watch<User>().uid == widget.user.uid,
            child: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
              foregroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
              child: const Icon(
                Icons.settings,
                size: 48,
                color: Color.fromRGBO(255, 163, 0, 1.0)
              ),
              onPressed: () {
                openDrawer();
              }
            ),
          ),
        ]
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // profile pic container (edit button, banner image and circular avatar)
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Image(
                  image: widget.user.banner,
                  width: double.infinity,
                  height: h/3,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: h/3 - w/4,
                  child: CircleAvatar(
                    radius: w/6,
                    backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
                    backgroundImage: widget.user.profile,
                  )
                )
              ]
            ),
            const SizedBox(height: 45,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: GestureDetector(
                onTap: (){}, // slide everything below the bar down to show user info (data joined and such)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (widget.user.username == 'bacon') ? const Image( image: AssetImage('assets/racketTag.png'), width: 25, height: 25,): const Text(''),
                    (widget.user.username == 'bacon') ? const SizedBox(width: 15,): const Text(''),
                    Text(
                      widget.user.username,
                      style: const TextStyle(
                        fontFamily: "dubai",
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 30,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 50),
                Container(
                  width: (totalUps / (totalUps + totalDowns))*(w-100),
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: const Color.fromRGBO(255, 163, 0, 1.0)
                  ),
                ),
                Container(
                  width: (totalDowns / (totalUps + totalDowns))*(w-100),
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: const Color.fromRGBO(170 , 0, 0, 1.0)
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  splashRadius: 0.1,
                  icon: const Icon(Icons.dashboard),
                  iconSize: w/6.5,
                  color: const Color.fromRGBO(255, 163, 0, 1.0)
                ),
                GestureDetector(
                  child: Image(
                    image: const AssetImage("assets/dPlus.png"),
                    width: w/6.5,
                    height: w/6.5,
                  ),
                  onTap: (){}
                ),
                GestureDetector(
                  child: Image(
                    image: const AssetImage("assets/dMinus.png"),
                    width: w/6.5,
                    height: w/6.5,
                  ),
                  onTap: (){}
                )
              ]
            ),
            const SizedBox(height: 30),

          ],
        )
      )
    );
  }
}