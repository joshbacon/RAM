import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/postlist.dart';
import 'package:ram/pages/chat.dart';
import 'package:ram/widgets/sidemenu.dart';
import 'package:ram/models/user.dart';
import 'package:ram/widgets/post.dart';
import 'package:intl/intl.dart';


class ProfilePage extends StatefulWidget {

  const ProfilePage(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int totalUps = 1;
  int totalDowns = 1;
  int filter = 0;

  List<Post> list = [];
  PostList posts = PostList.little();
  ScrollController controller = ScrollController();

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void addFriend() {
    widget.user.addFriend(context.read<User>().uid).then((_) => {
      setState(() {})
    });
  }

  void openDrawer() {
    setState(() {
      _drawerKey.currentState?.openDrawer();
    });
  }

  void setFilter(int index) {
    // at some point look into caching images
    if (index == 0) {
      filter = index; // query for the users posts
    } else if (index == 1) {
      filter = index; // query for posts liked by the user
    } else if (index == 2) {
      filter = index; // query for posts disliked by the user
    }
    _refresh();
  }

  Future<void> _refresh() async{
    posts.reset().then((_) {
      posts.getPosts(false, widget.user.uid, filter).then((_) {
        setState(() {
          list = posts.getList();
        });
      });
    });
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
      posts.getPosts(false, widget.user.uid, filter).then((_) {
        List<Post> newPosts = posts.getList();
        if (list != newPosts && newPosts.isNotEmpty) {
          setState(() {
            list = newPosts;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const SideMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Column(
        children: [
          Visibility(
            visible: context.watch<User>().uid != widget.user.uid,
            child: FloatingActionButton(
              heroTag: "backBtn",
              backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
              foregroundColor: Theme.of(context).colorScheme.background,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.primary
              ),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ),
          Visibility(
            visible: context.watch<User>().uid != widget.user.uid && !widget.user.isFriend!,
            child:  FloatingActionButton(
              heroTag: "addBtn",
              backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
              foregroundColor: Theme.of(context).colorScheme.background,
              child: Icon(
                Icons.group_add_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary
              ),
              onPressed: () {
                addFriend();
              }
            ),
          ),
          Visibility(
            visible: widget.user.isFriend ?? false,
            child:  FloatingActionButton(
              heroTag: "addBtn",
              backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
              foregroundColor: Theme.of(context).colorScheme.background,
              child: Icon(
                Icons.chat,
                size: 48,
                color: Theme.of(context).colorScheme.primary
              ),
              onPressed: () {
                // go to the chat room
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Chat()));
              }
            ),
          ),
          Visibility(
            visible: context.watch<User>().uid == widget.user.uid,
            child: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(255, 163, 0, 0.0),
              foregroundColor: Theme.of(context).colorScheme.background,
              child: Icon(
                Icons.settings,
                size: 48,
                color: Theme.of(context).colorScheme.primary
              ),
              onPressed: () {
                openDrawer();
              }
            ),
          ),
        ]
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refresh();
        },
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          controller: controller,
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
                      backgroundColor: Theme.of(context).colorScheme.background,
                      backgroundImage: widget.user.profile,
                    )
                  )
                ]
              ),
              const SizedBox(height: 45,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: widget.user.uid == '1',
                          child: const Row(
                            children: [
                              Image(
                                image: AssetImage('assets/racketTag.png'), width: 25, height: 25,
                              ),
                              SizedBox(width: 10,),
                            ]
                          ),
                        ),
                        Text(
                          widget.user.username,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Text(
                      "joined " + DateFormat('MMM d y').format(widget.user.joinedat),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Visibility(
                      visible: widget.user.bio != 'null',
                      child: Text(
                        widget.user.bio!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ]
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 50),
                  Container(
                    width: (widget.user.ups / (widget.user.ups + widget.user.downs))*(w-100),
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  Container(
                    width: (widget.user.downs / (widget.user.ups + widget.user.downs))*(w-100),
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Theme.of(context).colorScheme.secondary,
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
                    onPressed: () {
                      setFilter(0);
                    },
                    splashRadius: 0.1,
                    icon: Icon(
                      Icons.dashboard,
                      color: Theme.of(context).colorScheme.primary.withAlpha(filter == 0 ? 255 : 100),
                    ),
                    iconSize: w/6.5,
                    color: Theme.of(context).colorScheme.primary
                  ),
                  GestureDetector(
                    child: Image.asset(
                      "assets/dPlus.png",
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(filter == 1 ? 255 : 100),
                      colorBlendMode: BlendMode.modulate,
                      width: w/6.5,
                      height: w/6.5,
                    ),
                    onTap: () {
                      setFilter(1);
                    }
                  ),
                  GestureDetector(
                    child: Image.asset(
                      "assets/dMinus.png",
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(filter == 2 ? 255 : 100),
                      colorBlendMode: BlendMode.modulate,
                      width: w/6.5,
                      height: w/6.5,
                    ),
                    onTap: () {
                      setFilter(2);
                    }
                  )
                ]
              ),
              const SizedBox(height: 30),
              list.isEmpty ?
              const Text(
                "No posts yet.",
              ) :
              MasonryView(
                listOfItem: list,
                numberOfColumn: 2,
                itemBuilder: (item) {
                  return item;
                },
              ),
            ],
          )
        ),
      )
    );
  }
}