import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/widgets/post.dart';
import 'package:ram/widgets/sidemenu.dart';
import 'package:ram/models/user.dart';


class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var totalUps = 1;
  var totalDowns = 1;
  
  //var profileImage = const AssetImage('assets/defaultProfile.png');
  //var bannerImage = const AssetImage('assets/defaultBanner.png');

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void openDrawer() {
    setState(() {
      _drawerKey.currentState?.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    return Scaffold(
      key: _drawerKey,
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      drawer: const SideMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
        foregroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
        child: const Icon(Icons.settings, size: 48, color: Color.fromRGBO(255, 163, 0, 1.0)),
        onPressed: () { openDrawer(); }
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
                  image: context.watch<User>().banner,
                  width: double.infinity,
                  height: 288
                ),
                Positioned(
                  top: 181,
                  child: CircleAvatar(
                    radius: 72,
                    backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
                    backgroundImage: context.watch<User>().profile,
                  )
                )
              ]
            ),
            const SizedBox(height: 45,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (context.watch<User>().username == 'bacon') ? const Image( image: AssetImage('assets/racketTag.png'), width: 25, height: 25,): const Text(''),
                (context.watch<User>().username == 'bacon') ? const SizedBox(width: 15,): const Text(''),
                TextButton(
                  onPressed: (){}, // slide everything below the bar down to show user info (data joined and such)
                  child: Text(context.watch<User>().username,
                    style: const TextStyle(
                      fontFamily: "dubai",
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 30,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 50),
                Container(width: (totalUps / (totalUps + totalDowns))*250, height: 3, decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: const Color.fromRGBO(255, 163, 0, 1.0)
                  ),
                ),
                Container(width: (totalDowns / (totalUps + totalDowns))*250, height: 3, decoration:
                  BoxDecoration(
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
                  splashColor: Colors.transparent,
                  icon: const Icon(Icons.dashboard),
                  iconSize: 48,
                  color: const Color.fromRGBO(255, 163, 0, 1.0)
                ),
                GestureDetector(
                  child: const Image( image: AssetImage("assets/dPlus.png"), width: 48, height: 48,),
                  onTap: (){}
                ),
                GestureDetector(
                  child: const Image( image: AssetImage("assets/dMinus.png"), width: 48, height: 48,),
                  onTap: (){}
                )
              ]
            ),
            const SizedBox(height: 30),

            // show posts in 2 columns so you can look through them faster
            // maybe make it so when you tap a photo it switches between 1 column and 2 of them
            // that could be a cool animation too...
            //Row(
            //  children: [
            //    Column(
            //      children: const [
                    //Post(0),//{
                    //  'pid': 3,
                    //  'uid': '1',
                    //  'ups': 420,
                    //  'downs': 69,
                    //  'image': NetworkImage("http://192.168.2.17:80/../../ram_images/posts/1post2022_08_01_20-35-36.jpg")
                    //}),
                //  ],
                //),
                //Column(
                //  children: const [
                //    Post({
                //      'pid': 3,
                //      'uid': '1',
                //      'ups': 69,
                //      'downs': 420,
                //      'image': NetworkImage("http://192.168.2.17:80/../../ram_images/posts/1post2022_07_28_17-03-25.jpg")
                //    }),
                //  ],
                //),
              ],
            )
          //],
        //)
      )
    );
  }
}