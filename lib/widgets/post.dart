import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ram/models/user.dart';
import 'package:ram/pages/profile.dart';
import 'package:ram/widgets/fullimage.dart';
import 'package:ram/models/paths.dart' as paths;


class Post extends StatefulWidget {

  const Post(this.data, {Key? key}) : super(key: key);
  
  final Map<String, dynamic> data;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  // TODO:
  // - tapping the image makes it full screen and the comments appear when you scroll down (need a back button)
  // -- also have a add comment box at the top UNLESS it's in anon mode
  // - get interactions working

  Future<bool> interact(uid, up) async {
    
    var uri = Uri.parse(paths.interact());
    var request = http.MultipartRequest("POST", uri);

    request.fields['pid'] = widget.data['pid'].toString();
    request.fields['uid'] = uid;
    request.fields['up'] = up;
  
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<void> showProfile(context, user) async {
    final author = await user(widget.data['uid']);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(author)));
  }

  showFullImage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FullImage(widget.data)));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () {
              if (!widget.data['anon'] && context.read<User>().uid != widget.data['uid']){
                showProfile(context, context.read<User>().getUserInfo);
              }
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: CircleAvatar(
                    radius: min(24, w/6),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    backgroundImage: widget.data['profilepicture'],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    widget.data['username'],
                    style: const TextStyle(
                      fontFamily: "dubai",
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox( height: 10, ),
        GestureDetector(
          onTap: () {
            showFullImage(context);
          },
          child: Image(
            image: widget.data['image'],
            fit: BoxFit.fitWidth
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: !widget.data['anon'],
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Image(
                    image: AssetImage("assets/dPlus.png"),
                    width: 40,
                    height: 40,
                  ),
                  onPressed: () {
                    //setState(() {
                      widget.data['ups'] += 1;
                      interact(context.read<User>().uid, true);
                      // make a DB call to update post
                    //});
                  },
                ),
              ),
              const SizedBox( width: 15, height: 25 ),
              Container(
                width: (widget.data['ups'] / (widget.data['ups'] + widget.data['downs']))*(w-(widget.data['anon']?60:156)),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Theme.of(context).colorScheme.primary
                ),
              ),
              Container(
                // width: (widget.data['downs'] / (widget.data['ups'] + widget.data['downs']))*(w-156),
                width: (widget.data['downs'] / (widget.data['ups'] + widget.data['downs']))*(w-(widget.data['anon']?60:156)),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Theme.of(context).colorScheme.secondary
                ),
              ),
              const SizedBox( width: 15, height: 25 ),
              Visibility(
                visible: !widget.data['anon'],
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Image( image: AssetImage("assets/dMinusRed.png"), width: 40, height: 40,),
                  onPressed: () {
                    //setState(() {
                      widget.data['downs'] += 1;
                      interact(context.read<User>().uid, false);
                      // make a DB call to update post
                    //});
                  },
                ),
              ),
            ],
          )
        ),
        Center(
          child: Container(width: w, height: 3, decoration:
            BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: const Color.fromARGB(26, 0, 0, 0)
            ),
          ),
        ),
        const SizedBox( height: 10 ),
      ],
    );
  }
}
