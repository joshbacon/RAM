import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ram/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/user.dart';
import 'package:image_picker/image_picker.dart';


class SideMenu extends StatefulWidget {

  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  //var profileImage = const AssetImage('assets/defaultProfile.png');
  //var bannerImage = const AssetImage('assets/defaultBanner.png');

  TextEditingController newUsername = TextEditingController();

  bool showUserBox = false;
  bool showUserErr = false;
  bool showProfileErr = false;
  bool showBannerErr = false;

  Future<XFile?> acceptImage() async {
    ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.gallery,
    );
  }

  void logout() {
    showUserBox = false;
    showUserErr = false;
    showProfileErr = false;
    showBannerErr = false;
    context.read<User>().logout();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<void> _showDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            msg,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          actions: <Widget>[
            msg.contains('logout') ?
            TextButton(
              child: const Text( "cancel",
                style: TextStyle(
                  fontFamily: "dubai",
                  color: Color.fromARGB(255, 56, 56, 56),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ) : const Text(''),
            TextButton(
              child: const Text(
                "ok",
                style: TextStyle(
                  fontFamily: "dubai",
                  color: Color.fromARGB(255, 56, 56, 56),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (msg.contains('logout')) logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: context.watch<User>().profile,
              width: double.infinity,
              alignment: Alignment.topLeft,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: context.watch<User>().banner,
              )
            ),
          ),
          Text(
            "Settings",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Update Username'),
            iconColor: Colors.white,
            textColor: Colors.white,
            onTap: () => {
              //setState(() {
                showUserBox = !showUserBox
              //}),
            },
          ),
          Visibility(
            visible: showUserBox,
            child: ListTile(
              tileColor: const Color.fromRGBO(69, 69, 69, 1.0),
              title: TextField(
                controller: newUsername,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.check_box_rounded, size: 34,),
                onPressed: () async {
                  if (await context.read<User>().updateUsername(newUsername.text)) {
                    //setState(() {
                      _showDialog('Your username has been updated.');
                      showUserBox = false;
                      newUsername.clear();
                      showUserErr = false;
                    //});
                  } else {
                    //setState(() {
                      showUserErr = true;
                    //});
                  }
                },
              ),
              iconColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              onTap: () => {},
            ),
          ),
          Visibility(
            visible: showUserErr,
            child: const Text(
              "Username is already taken.",
              style: TextStyle(
                fontFamily: "dubai",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.supervised_user_circle_rounded),
            title: const Text('Update Profile Picture'),
            iconColor: Colors.white,
            textColor: Colors.white,
            onTap: () async {
              XFile? imagePicked = await acceptImage();
              if ( imagePicked != null && await context.read<User>().updateProfilePicture(File(imagePicked.path)) ) {
                //setState(() {
                  _showDialog('Your profile picture has been updated.');
                  showProfileErr = false;
                //});
              } else {
                //setState(() {
                  showProfileErr = true;
                //});
              }
            },
          ),
          Visibility(
            visible: showProfileErr,
            child: const Text(
              "whoops, try again",
              style: TextStyle(
                fontFamily: "dubai",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.photo_size_select_actual_rounded),
            title: const Text('Update Banner Picture'),
            iconColor: Colors.white,
            textColor: Colors.white,
            onTap: () async {
              XFile? imagePicked = await acceptImage();
              if ( imagePicked != null && await context.read<User>().updateBannerPicture(File(imagePicked.path)) ) {
                //(() {
                  _showDialog("Your banner picture has been updated");
                  showBannerErr = false;
                //});
              } else {
                //setState(() {
                  showBannerErr = true;
                //});
              }
            },
          ),
          Visibility(
            visible: showBannerErr,
            child: const Text(
              "whoops, try again",
              style: TextStyle(
                fontFamily: "dubai",
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () => {
                _showDialog("Are you sure you want to logout?")
              },
            ),
          //)
        ],
      ),
    );
  }
}