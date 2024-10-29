import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/user.dart';
import 'package:ram/pages/profile.dart';

class CommentCard extends StatefulWidget {
  const CommentCard(this.data, {Key? key}) : super(key: key);

  final Map<String, dynamic> data;
  
  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  // steps:
  // - bring in user data
  // - bring in comment data
  // - dispaly user / comment data
  // - navigate to users profile on press

  Future<void> showProfile(context, user) async {
    final author = await user(widget.data['uid']);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(author)));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (!widget.data['anon'] && context.read<User>().uid.toString() != widget.data['uid'].toString()){
              showProfile(context, context.read<User>().getUserInfo);
            }
          },
          child: CircleAvatar(
            radius: min(24, w/6),
            backgroundColor: Theme.of(context).colorScheme.background,
            backgroundImage: widget.data['profilepicture'],
          )
        ),
        Column(
          children: [
            Text(
              widget.data['username']
            ),
            Text(
              widget.data['comment']
            )
          ],
        )
      ],
    );
  }
}