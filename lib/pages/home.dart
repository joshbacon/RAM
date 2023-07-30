import 'package:flutter/material.dart';
import 'package:ram/widgets/post.dart';
import 'package:ram/widgets/news.dart';
import 'package:ram/models/postlist.dart';
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

  // TODO:
  // - error handling
  // -- when we are out of posts after srcolling to bottom

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
    setState(() {
      isLoading = true;
    });
    postList.reset();
    postList.getPosts().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
    setState(() {
      isLoading = true;
    });
    postList.getPosts().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
      body: RefreshIndicator(
        color: const Color.fromRGBO(255, 163, 0, 1.0),
        backgroundColor: const Color.fromARGB(255, 69, 69, 69),
        onRefresh: () async {
          _refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
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
              postList.isEmpty() ?
              Column(children: const [
                SizedBox(height: 100),
                CircularProgressIndicator(color: Color.fromRGBO(255, 163, 0, 1.0))
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