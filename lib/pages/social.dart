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
  // - also why is home and profile a scaffold but this and upload aren't? see if they should be...

  Timer? _debounce;

  List<ProfileCard> searchList = [];
  List<ProfileCard> friendList = [];
  List<ProfileCard> requestList = [];

  _getFriends() async {
    List<User> results = await context.read<User>().getFriends();
    setState(() {
      friendList = results.map((user) => ProfileCard(user)).toList();
    });
  }

  _getRequests() async {
    List<User> results = await context.read<User>().getRequests();
    setState(() {
      requestList = results.map((user) => ProfileCard(user)).toList();
    });
  }

  _onSearchChanged(query, uid) {
    if (query == "") {
      setState(() {
        searchList = [];
      });
      return;
    }
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await http.get(
        Uri.parse(paths.searchUsers(query, context.read<User>().uid))
      );
      if (response.statusCode == 200) {
        try {
          List<dynamic> results = json.decode(response.body);
          for (var user in results) {
            if ( user['status'] ){
              final response = await http.get(
                Uri.parse(paths.searchUsers(query, context.read<User>().uid))
              );
              if (response.statusCode == 200) {
                try {
                  List<dynamic> users = json.decode(response.body);
                  List<ProfileCard> newList = [];
                  for (var uu in users) {
                    if ( uu['status'] ){
                      User profile = User({
                        'uid': uu['uid'].toString(),
                        'username': uu['username'],
                        'bio': uu["bio"].toString(),
                        'joinedat': DateTime.parse(uu["joinedat"]).toLocal(),
                        'ups': uu['ups'] == 0 ? 1 : uu['ups'],
                        'downs': uu['downs'] == 0 ? 1 : uu['downs'],
                        'profile': uu['profile'] != null ? NetworkImage(paths.image(uu["profile"].toString())) : const AssetImage('assets/defaultProfile.png'),
                        'banner': uu['banner'] != null ? NetworkImage(paths.image(uu["banner"].toString())) : const AssetImage('assets/defaultBanner.png'),
                        'isFriend': uu['isFriend'] == 1
                      });
                      if (profile.uid != uid) {
                        newList.add(ProfileCard(profile));
                      }
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
          // Map<String, dynamic> result = json.decode(response.body);
          setState(() {
            searchList = [];
          });
        }
      }
    });
  }

  @override
  void initState() {
    _getFriends();
    _getRequests();
    super.initState();
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
          TextField(
            onChanged: (query) {
              _onSearchChanged(query, context.read<User>().uid);
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
          Visibility(
            visible: searchList.isEmpty && requestList.isNotEmpty,
            child: Column(
              children: [
                const SizedBox(height: 15,),
                Text(
                  "Requests",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                ListView.builder(
                  // key: const ValueKey(1),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: requestList.length,
                  itemBuilder: (context, index) {
                    return requestList[index];
                  },
                ),
              ],
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
                      children: [
                        Text(
                          'Friends',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            shadows: <Shadow>[
                              const Shadow(
                                offset: Offset(0.0, 1.0),
                                blurRadius: 10.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Visibility(
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
                      ]
                    ),
                  );
                },
              );
            },
            child: Text(
              'Friends',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}