import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/group.dart';
import 'package:ram/models/user.dart';
import 'package:ram/widgets/groupcard.dart';
import 'package:ram/widgets/profilecard.dart';
import 'package:ram/models/paths.dart' as paths;
import 'package:http/http.dart' as http;

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {

  final FocusNode _focus = FocusNode();

  Timer? _debounce;

  List<ProfileCard> searchList = [];
  List<ProfileCard> friendList = [];
  List<ProfileCard> requestList = [];
  List<GroupCard> groupList = [];

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

  _getGroups() async {
    List<Group> results = await context.read<User>().getGroups();
    setState(() {
      groupList = results.map((group) => GroupCard(group)).toList();
    });
  }

  _toggleDebounce(query, uid) {
    if (query == "") {
      setState(() {
        searchList = [];
      });
      return;
    }
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () => _onSearchChanged(query, uid));
  }

  _onSearchChanged(query, uid) async {
    String uid = context.read<User>().uid;
    final response = await http.get(
      Uri.parse(paths.searchUsers(query, uid))
    );
    if (response.statusCode == 200) {
      try {
        List<dynamic> results = json.decode(response.body);
        for (var user in results) {
          if ( user['status'] ){
            final response = await http.get(
              Uri.parse(paths.searchUsers(query, uid))
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
                      'ups': uu['ups'] == 0 ? 1 : int.parse(uu['ups']),
                      'downs': uu['downs'] == 0 ? 1 : int.parse(uu['downs']),
                      'profile': uu['profile'] != null ? NetworkImage(paths.image(uu["profile"].toString())) : const AssetImage('assets/defaultProfile.png'),
                      'banner': uu['banner'] != null ? NetworkImage(paths.image(uu["banner"].toString())) : const AssetImage('assets/defaultBanner.png'),
                      'isFriend': uu['isFriend'] == '1'
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
  }

  @override
  void initState() {
    _getFriends();
    _getRequests();
    _getGroups();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 10),
      child: Column(
        children: [
          TextField(
            focusNode: _focus,
            onChanged: (query) {
              _toggleDebounce(query, context.read<User>().uid);
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

          // Show the search results if there are any
          Visibility(
            visible: searchList.isNotEmpty || _focus.hasFocus,
            child: Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    return searchList[index];
                  },
                ),
              ),
            ),
          ),

          // Show friend requests if there are any and you're not searching
          Visibility(
            visible: searchList.isEmpty && !_focus.hasFocus && requestList.isNotEmpty,
            child: Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const Text('Requests'),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: requestList.length,
                        itemBuilder: (context, index) {
                          return requestList[index];
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Show the groups if there are no search results and the serach box doesn't have focus
          Visibility(
            visible: searchList.isEmpty && !_focus.hasFocus && groupList.isNotEmpty,
            child: Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const Text('Groups'),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groupList.length,
                        itemBuilder: (context, index) {
                          return groupList[index];
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Show an empty space if all search results are empty
          Visibility(
            visible: searchList.isEmpty && requestList.isEmpty && groupList.isEmpty,
            child: const Spacer(),
          ),
          const Divider(thickness: 3,),

          // Bottom friends modal
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                          child: Text(
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
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.background,
                        ),
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
                        Visibility(
                          visible: friendList.isEmpty,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              "No added friends yet.",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
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