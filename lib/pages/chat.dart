import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final String user1 = "josh";
  final String user2 = "luke";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user2),
      ),
      body: Column(
        children: [
          const Divider(height: 2.0),
          const Message("hey", false, AssetImage('assets/defaultProfile.png')),
          const Spacer(),
          Row(
            children: [
              const TextField(),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
            ],
          ),
        ]
      ),
    );
  }
}

class Message extends StatelessWidget {
  const Message(this.message, this.sender, this.profileImage, {Key? key}) : super(key: key);

  final String message;
  final bool sender;
  final dynamic profileImage;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (sender) {
      return Row(
        children: [
          const Spacer(),
          Container(
            child: Text(message),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
          ),
          const SizedBox(width: 15.0),
          CircleAvatar(
            radius: w/15,
            backgroundColor: Theme.of(context).colorScheme.background,
            backgroundImage: profileImage,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          CircleAvatar(
            radius: w/15,
            backgroundColor: Theme.of(context).colorScheme.background,
            backgroundImage: profileImage,
          ),
          const SizedBox(width: 15.0),
          Container(
            child: Text(message),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
          ),
          const Spacer(),
        ],
      );
    }
  }
}