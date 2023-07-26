import 'package:flutter/material.dart';
import 'package:ram/widgets/post.dart';
import 'package:ram/widgets/news.dart';
// import 'package:ram/models/postlist.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paths.dart' as paths;

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //PostList postList = PostList();
  List<Post> postList = [];
  int nextPID = 0;
  ScrollController controller = ScrollController();
  bool _isLoading = false;

  Future<void> getPost() async {

    final response = await http.get(
      Uri.parse(paths.getPost(nextPID.toString()))
    );
    // make get call here and set data
    if (response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body);
      if ( data['status'] ){
        data.remove('status');
        data['profilepicture'] = NetworkImage(paths.image(data['profilepicture']));
        data['image'] = NetworkImage(paths.image(data['image']));
        if(data['ups'] == 0 && data['downs'] == 0) {
          data['ups']++;
          data['downs']++;
        }
        setState(() {
          postList.add(Post(data));
          nextPID = data['pid']-1;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getPost();
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
        //postList.addXPosts(1);
        //Post nextPost = Post(nextPID);
        //postList.add(nextPost);
        //nextPID = nextPost.pid - 1;
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
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          getPost();
          //postList.add(Post(nextPID));
          //nextPID = postList[postList.length-1].pid - 1;
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
          nextPID = 0;
          getPost();
          //setState(() {
          //  postList = [Post(0)];
          //  //postList.add(nextPost);
          //  //nextPID = nextPost.pid - 1;
          //  //postList.getNewestPost();
          //});
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
              Center(
                child: Container(width: w, height: 3, decoration:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: const Color.fromARGB(26, 0, 0, 0)
                  ),
                ),
              ),
              postList.isEmpty ?
              Column(children: const [
                SizedBox(height: 100),
                CircularProgressIndicator(color: Color.fromRGBO(255, 163, 0, 1.0))
              ]) :
              ListView.builder(
                // key: const ValueKey(1),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  return postList[index];
                },
              )
            ]
          )
        )
      )
    );
  }

}