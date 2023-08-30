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

  String newText = "";

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
    showUserErr = false;
    showProfileErr = false;
    showBannerErr = false;
    context.read<User>().logout();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _updateText() {
    // print(newText.text + " AND " + newText.text.length.toString());
    // setState(() {
    //   print(255 - newText.text.length);
    //   remainingChars = (255 - newText.text.length).toString();
    //   print(remainingChars);
    // });
    // print(remainingChars);
  }

  Future<void> _showUpdateDialog(String type) async {
    // print(newText.text);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Update " + type,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          actions: <Widget>[
            TextField(
              maxLength: 255,
              minLines: type.contains('Bio') ? 3 : 1,
              maxLines: type.contains('Bio') ? 5 : 1,
              onChanged: (text) {
                setState(() {
                  newText = text;             
                });
              },
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                hintStyle: TextStyle(
                  fontFamily: "dubai",
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Row(children: [
              TextButton(
                child: Text(
                  "cancel",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "ok",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (type.contains('Username')) {
                    // make the update username call
                    context.read<User>().updateUsername(newText).then((result) {
                      if (result) {
                        _showMsgDialog(type + " has been updated");
                      } else {
                        _showMsgDialog("Something went wrong, " + type + " was not updated");
                      }
                    });
                  } else if (type.contains('Bio')) {
                    // make the update bio call
                    context.read<User>().updateBio(newText).then((result) {
                      if (result) {
                        _showMsgDialog(type + " has been updated");
                      } else {
                        _showMsgDialog("Something went wrong, " + type + " was not updated");
                      }
                    });
                  }
                },
              ),
            ],),
          ],
        );
      },
    );
  }

  Future<void> _showMsgDialog(String msg) async {
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
              child: Text(
                "cancel",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ) : Container(),
            TextButton(
              child: Text(
                "ok",
                style: Theme.of(context).textTheme.bodyMedium,
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
  void initState() {
    // newText.addListener(_updateText);
    super.initState();
  }

  @override
  void dispose() {
    // newText.dispose();
    super.dispose();
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
          const SizedBox(height: 10),
          Text(
            "Settings",
            style: Theme.of(context).textTheme.titleMedium?.apply(decoration: TextDecoration.none),
          ),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: Text(
              'Update Username',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            iconColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onBackground,
            onTap: () => {
              _showUpdateDialog("Username")
              // setState(() {
              //   showUserBox = !showUserBox;
              // }),
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_rounded),
            title: Text(
              'Update Bio',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            iconColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onBackground,
            onTap: () => {
              _showUpdateDialog("Bio")
              // setState(() {
              //   showUserBox = !showUserBox;
              // }),
            },
          ),
          // Visibility(
          //   visible: showUserBox,
          //   child: ListTile(
          //     tileColor: const Color.fromRGBO(69, 69, 69, 1.0),
          //     title: TextField(
          //       controller: newText,
          //       onTapOutside: (event) => FocusScope.of(context).unfocus(),
          //       style: Theme.of(context).textTheme.bodySmall,
          //     ),
          //     trailing: IconButton(
          //       alignment: Alignment.centerRight,
          //       icon: const Icon(Icons.check_box_rounded, size: 34,),
          //       onPressed: () async {
          //         if (newText.text.isNotEmpty && await context.read<User>().updateUsername(newText.text)) {
          //           //setState(() {
          //             _showMsgDialog('Your username has been updated.');
          //             showUserBox = false;
          //             newText.clear();
          //             showUserErr = false;
          //           //});
          //         } else {
          //           //setState(() {
          //             showUserErr = true;
          //           //});
          //         }
          //       },
          //     ),
          //     iconColor: Theme.of(context).colorScheme.primary,
          //     textColor: Colors.white,
          //     onTap: () => {},
          //   ),
          // ),
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
            title: Text(
              'Update Profile Picture',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            iconColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onBackground,
            onTap: () async {
              XFile? imagePicked = await acceptImage();
              if ( imagePicked != null && await context.read<User>().updateProfilePicture(File(imagePicked.path)) ) {
                //setState(() {
                  _showMsgDialog('Your profile picture has been updated.');
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
            title: Text(
              'Update Banner Picture',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            iconColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onBackground,
            onTap: () async {
              XFile? imagePicked = await acceptImage();
              if ( imagePicked != null && await context.read<User>().updateBannerPicture(File(imagePicked.path)) ) {
                //(() {
                  _showMsgDialog("Your banner picture has been updated");
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
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              iconColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onBackground,
              onTap: () => {
                _showMsgDialog("Are you sure you want to logout?")
              },
            ),
          //)
        ],
      ),
    );
  }
}