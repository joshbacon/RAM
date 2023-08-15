import 'package:flutter/material.dart';
import 'package:ram/widgets/news.dart';
import 'package:ram/models/postlist.dart';
import '../widgets/loader.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
    postList.getPosts(false, "0").then((_) {
      setState(() {
        isLoading = true;
        isLoading = false;
      });
    });
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
    postList.getPosts(false, "0").then((_) {
      setState(() {
        isLoading = true;
        isLoading = false;
      });
    });
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
                child: Text(
                  "Random Access Memes",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const News(),
              const Divider( 
                thickness: 3,
              ),
              postList.isEmpty() ?
              const Column(children: [
                SizedBox(height: 100),
                Loader()
              ]) :
              ListView.builder(
                // key: const ValueKey(1),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: postList.length(),
                itemBuilder: (context, index) {
                  return postList.at(index);
                },
              )
            ]
          )
        )
      )
    );
  }

}