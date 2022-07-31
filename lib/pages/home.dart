import 'package:flutter/material.dart';
import 'package:ram/widgets/post.dart';
import 'package:ram/models/postlist.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PostList postList = PostList();
  //ScrollController controller = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      postList.getPost();
    });
    //controller.addListener(_scrollListener);
  }

  //@override
  //void dispose() {
  //  //controller.removeListener(_scrollListener);
  //  controller.dispose();
  //  super.dispose();
  //}

  //void _scrollListener() {
  //  if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
  //    setState(() {
  //      _isLoading = true;
  //      postList.addXPosts(1);
  //    });
  //  }
  //  //print(controller.position.extentAfter);
  //  //if (controller.position.extentAfter < 500) {
  //  //  setState(() {
  //  //    postList.addAll(List.generate(1, (index) => Post(index)));
  //  //  });
  //  //}
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        print('blist length = ' + postList.len.toString());
        setState(() {
          postList.getPost();
        });
        print('alist length = ' + postList.len.toString());
      }),
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
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
            ListView.builder(
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