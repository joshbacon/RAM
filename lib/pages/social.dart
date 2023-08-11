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
  // - bottomSheetTheme: BottomSheetThemeData(backgroundColor: Theme.of(context).colorScheme.background)
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
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            style: const TextStyle(
              fontFamily: "dubai",
              decoration: TextDecoration.none,
              color: Colors.white,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(91, 91, 91, 1.0),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
              ),
              prefixIcon: Icon(
                Icons.search_outlined,
                color: Theme.of(context).colorScheme.primary
              ),
              hintText: "search...",
              hintStyle: const TextStyle(
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
            child: Text(
              'Friends',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "dubai",
                decoration: TextDecoration.none,
                color: Theme.of(context).colorScheme.primary,
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