import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/user.dart';
import 'package:ram/widgets/profilecard.dart';
import 'package:ram/models/paths.dart' as paths;
import 'package:http/http.dart' as http;

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {

  // TODO:
  // - implement searching users
  // - implement a friend system (request/accept)
  // - implement a chat feature
  //
  // - really should have a top level theme, then add this:
  // - bottomSheetTheme: BottomSheetThemeData(backgroundColor: Theme.of(context).colorScheme.background)
  //
  // - also why is home and profile a scaffold but this and upload aren't? see if they should be...

  TextEditingController searchTerm = TextEditingController();

  Timer? _debounce;

  List<ProfileCard> searchList = [];
  List<ProfileCard> friendList = [];

  _getFriends() async {
    List<User> results = await context.read<User>().getFriends();
    friendList = results.map((user) => ProfileCard(user)).toList();
  }

  _onSearchChanged(query, user) {
    if (query == "") return;
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await http.get(
        Uri.parse(paths.searchUsers(query))
      );
      if (response.statusCode == 200) {
        try {
          List<dynamic> results = json.decode(response.body);
          for (var user in results) {
            if ( user['status'] ){
              final response = await http.get(
                Uri.parse(paths.searchUsers(query))
              );
              if (response.statusCode == 200) {
                try {
                  List<dynamic> results = json.decode(response.body);
                  List<ProfileCard> newList = [];
                  for (var user in results) {
                    if ( user['status'] ){
                      User profile = User({
                        'uid': user['uid'].toStrin(),
                        'username': user['username'],
                        'profile': user['profile'] != null ? NetworkImage(paths.image(user["profile"].toString())) : null,
                        'banner': user['banner'] != null ? NetworkImage(paths.image(user["banner"].toString())) : null
                      });
                      newList.add(ProfileCard(profile));
                    }
                  }
                  setState(() {
                    searchList = newList;
                  });
                } catch (e) {
                  // Map<String, dynamic> result = json.decode(response.body);
                  setState(() {
                    searchList = [];
                  });
                }
              }
            } else {
              setState(() {
                searchList = [];
              });
            }
          }
        } catch (e) {
          Map<String, dynamic> result = json.decode(response.body);
          if (!result['status']){
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 10),
      child: Column(
        children: [
          TextFormField(
            controller: searchTerm,
            onChanged: (query) {
              _onSearchChanged(query, context.read<User>());
            },
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
          Visibility(
            visible: searchList.isNotEmpty,
            child: ListView.builder(
              // key: const ValueKey(1),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                return searchList[index];
              },
            ),
          ),
          const Spacer(flex: 1,),
          const Divider(thickness: 3,),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  _getFriends();
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Visibility(
                      visible: friendList.isNotEmpty,
                      child: ListView.builder(
                        // key: const ValueKey(1),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: friendList.length,
                        itemBuilder: (context, index) {
                          return friendList[index];
                        },
                      ),
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