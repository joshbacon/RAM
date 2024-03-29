import 'package:flutter/material.dart';
import 'package:ram/pages/login.dart';
import 'package:ram/models/postlist.dart';
import 'package:ram/widgets/loader.dart';

class AnonPage extends StatefulWidget {
  const AnonPage({Key? key}) : super(key: key);

  @override
  State<AnonPage> createState() => _AnonPageState();
}

class _AnonPageState extends State<AnonPage> {

  PostList postList = PostList();
  ScrollController controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refresh();
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  void _refresh() async {
    postList.reset();
    await postList.getPosts(true, "0", 0);
    setState(() { });
  }

  void _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
      await postList.getPosts(true, "0", 0);
      setState(() { });
    }
  }

  void onTap(index) {
    if (index == 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      controller.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeOut);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: const Color.fromARGB(255, 69, 69, 69),
        onRefresh: () async {
          _refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          child: postList.isEmpty ?
            const Column(
              children: [
                SizedBox(height: 100),
                Loader()
              ]
            ) :
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return postList.at(index);
              },
            ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        elevation: 1,
        iconSize: 35,
        items: const [
          BottomNavigationBarItem(
            label: "login",
            icon: Icon(Icons.logout_outlined)
          ),
          BottomNavigationBarItem(
            label: "back to top",
            icon: Icon(Icons.upgrade_outlined)
          ),
        ]
      ),
    );
  }
}