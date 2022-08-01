import 'package:flutter/material.dart';
import 'package:ram/widgets/post.dart';
import 'package:ram/widgets/news.dart';
import 'package:ram/models/postlist.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PostList postList = PostList();
  ScrollController controller = ScrollController();
  bool _isLoading = false;

  Future<void> getInit() async {
    //setState(() {
    //  //while (postList.len == 0) {
    //    postList = PostList();
    // // }
    //  //postList.addXPosts(1);
    //});
  }

  @override
  void initState() {
    super.initState();
    //getInit();
    setState(() {
      postList.getNewestPost();
    });
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    //controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
      setState(() {
        _isLoading = true;
        postList.addXPosts(1);
      });
    }
    //print(controller.position.extentAfter);
    //if (controller.position.extentAfter < 500) {
    //  setState(() {
    //    postList.addAll(List.generate(1, (index) => Post(index)));
    //  });
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          postList.getPost();
          //postList.getNewestPost();
        });
      }),
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      body: RefreshIndicator(
        color: const Color.fromRGBO(255, 163, 0, 1.0),
        backgroundColor: const Color.fromARGB(255, 69, 69, 69),
        onRefresh: () async {
          //clear the list
          //postList.removeXPosts(postList.len);
          // run get first post again
          print('refreshing...');
          setState(() {
            postList.getNewestPost();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          //controller: controller,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 15),
                child: Text("Random Access Memes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "dubai",
                    decoration: TextDecoration.underline,
                    color: Color.fromRGBO(255, 163, 0, 1.0),
                    fontSize: 28,
                    height: 1,
                  ),
                ),
              ),
              const News(),
              postList.len == 0 ?
              Column(children: const [
                SizedBox(height: 100),
                CircularProgressIndicator(color: Color.fromRGBO(255, 163, 0, 1.0))
              ]) :
              ListView.builder(
                key: const ValueKey(1),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: postList.len,
                itemBuilder: (context, index) {
                  return Post(postList.data.elementAt(index));
                },
              )
            ]
          )
        )
      )
    );
  }

}





          //const Padding(
          //  padding: EdgeInsets.fromLTRB(0, 50, 0, 15),
          //  child: Text("Random Access Memes",
          //    textAlign: TextAlign.center,
          //    style: TextStyle(
          //      fontFamily: "dubai",
          //      decoration: TextDecoration.underline,
          //      color: Color.fromRGBO(255, 163, 0, 1.0),
          //      fontSize: 28,
          //      height: 1,
          //    ),
          //  ),
          //),