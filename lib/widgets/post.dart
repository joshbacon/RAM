import 'dart:convert';
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

  Future<bool> interact(uid, up) async {
    // Grab the most recent interaction from this user on this post
    final response = await http.get(
      Uri.parse(paths.checkInteraction(uid, widget.data['pid'].toString()))
    );
    Map<String, dynamic> result = <String, dynamic>{};
    if (response.statusCode == 200) {
      try {
        result = json.decode(response.body);
        if ( result['status'] ) {
          result['up'] = result['up'] == 1;
          result['date'] = DateTime.parse(result['date']);
        }
      } catch (e) {
        // Map<String, dynamic> result = json.decode(response.body);
      }
    }

    // only process interaction if it's not a repeat
    if (!result['status'] || (result['status'] && result['up'] != up)) {
      setState(() {
        if (!result['status']) {
          up ? widget.data['ups'] += 1 : widget.data['downs'] += 1;
        } else if (result['status'] && result['up'] != up){
          if (up) {
            widget.data['ups'] += 1;
            widget.data['downs'] -= 1;
          } else {
            widget.data['ups'] -= 1;
            widget.data['downs'] += 1;
          }
        }
      });

      var uri = Uri.parse(paths.interact());
      var request = http.MultipartRequest("POST", uri);

      request.fields['pid'] = widget.data['pid'].toString();
      request.fields['uid'] = uid.toString();
      request.fields['up'] = up.toString();
    
      var response = await request.send();
      return response.statusCode == 200;
    }
    return false;
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
    int ups = widget.data['ups'] == 0 && widget.data['downs'] == 0 ? 1 : widget.data['ups'];
    int downs = widget.data['ups'] == 0 && widget.data['downs'] == 0 ? 1 : widget.data['downs'];
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
                    interact(context.read<User>().uid, true);
                  },
                ),
              ),
              const SizedBox( width: 15, height: 25 ),
              Container(
                width: (ups / (ups + downs))*(w-(widget.data['anon']?60:156)),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Theme.of(context).colorScheme.primary
                ),
              ),
              Container(
                width: (downs / (ups + downs))*(w-(widget.data['anon']?60:156)),
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
                    interact(context.read<User>().uid, false);
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
