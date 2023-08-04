import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ram/widgets/profilecard.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {

  TextEditingController searchTerm = TextEditingController();


  // TODO:
  // - implement searching users
  // - implement a friend system (request/accept)
  // - implement a chat feature
  //
  // - really should have a top level theme, then add this:
  // - bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color.fromRGBO(49, 49, 49, 1.0))
  //
  // - also why is home and profile a scaffold but this and upload aren't? see if they should be...

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 10),
      child: Column(
        children: [
          TextFormField(
            controller: searchTerm,
            style: const TextStyle(
              fontFamily: "dubai",
              decoration: TextDecoration.none,
              color: Colors.white,
              fontSize: 18,
            ),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(91, 91, 91, 1.0),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(255, 163, 0, 1.0))
              ),
              prefixIcon: Icon(
                Icons.search_outlined,
                color: Color.fromRGBO(255, 163, 0, 1.0)
              ),
              hintText: "search...",
              hintStyle: TextStyle(
                fontFamily: "dubai",
                color: Color.fromARGB(255, 223, 223, 223),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const Spacer(flex: 1,),
          const Divider(thickness: 3,),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: const [
                        ProfileCard(),
                        ProfileCard(),
                        ProfileCard(),
                        ProfileCard(),
                        ProfileCard(),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text(
              'Friends',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "dubai",
                decoration: TextDecoration.none,
                color: Color.fromRGBO(255, 163, 0, 1.0),
                fontSize: 21,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}