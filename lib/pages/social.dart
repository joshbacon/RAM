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
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 10),
      child: Column(
        children: [
          TextFormField(
            controller: searchTerm,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: "search...",
              prefixIcon: Icon(
                Icons.search_outlined,
                color: Theme.of(context).colorScheme.primary
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
                  return const SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
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