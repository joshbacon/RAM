import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/user.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final ScrollController _scrollController = ScrollController(
    // initialScrollOffset: 1.0,
    keepScrollOffset: true,
  );

  static const String user1 = "josh";
  static const String user2 = "luke";
  static const int uid = 2;
  static const int group = 0;

  TextEditingController message = TextEditingController();
  // String message = "";

  final List<Message> messages = [
    const Message("hey", false, AssetImage('assets/defaultProfile.png')),
    const Message("hi", true, AssetImage('assets/defaultProfile.png')),
    const Message("you're so cool", false, AssetImage('assets/defaultProfile.png')),
    const Message("I know, I made this app. but then we right something completely stupid here and just see what happens", true, AssetImage('assets/defaultProfile.png')),
    const Message("you must be so smart", false, AssetImage('assets/defaultProfile.png')),
    const Message("hey", false, AssetImage('assets/defaultProfile.png')),
    const Message("hi", true, AssetImage('assets/defaultProfile.png')),
    const Message("you're so cool", false, AssetImage('assets/defaultProfile.png')),
    const Message("I know, I made this app", true, AssetImage('assets/defaultProfile.png')),
    const Message("you must be so smart", false, AssetImage('assets/defaultProfile.png')),
    const Message("hey", false, AssetImage('assets/defaultProfile.png')),
    const Message("hi", true, AssetImage('assets/defaultProfile.png')),
    const Message("you're so cool", false, AssetImage('assets/defaultProfile.png')),
    const Message("I know, I made this app", true, AssetImage('assets/defaultProfile.png')),
    const Message("you must be so smart", false, AssetImage('assets/defaultProfile.png')),
    const Message("hey", false, AssetImage('assets/defaultProfile.png')),
    const Message("hi", true, AssetImage('assets/defaultProfile.png')),
    const Message("you're so cool", false, AssetImage('assets/defaultProfile.png')),
    const Message("I know, I made this app", true, AssetImage('assets/defaultProfile.png')),
    const Message("you must be so smart", false, AssetImage('assets/defaultProfile.png')),
    const Message("hey", false, AssetImage('assets/defaultProfile.png')),
    const Message("hi", true, AssetImage('assets/defaultProfile.png')),
    const Message("you're so cool", false, AssetImage('assets/defaultProfile.png')),
    const Message("I know, I made this app", true, AssetImage('assets/defaultProfile.png')),
    const Message("you must be so smart", false, AssetImage('assets/defaultProfile.png')),
    const Message("hey", false, AssetImage('assets/defaultProfile.png')),
    const Message("hi", true, AssetImage('assets/defaultProfile.png')),
    const Message("you're so cool", false, AssetImage('assets/defaultProfile.png')),
    const Message("I know, I made this app", true, AssetImage('assets/defaultProfile.png')),
    const Message("you must be so smart", false, AssetImage('assets/defaultProfile.png')),
  ];

  _sendMessage() async {
    if (message.text.isEmpty) return;

    final text = message.text;
    message.text = "";
    messages.add(Message(text, true, const AssetImage('assets/defaultProfile.png')));
    _scrollToBottom();

    if (!await context.read<User>().sendMessage(uid, group, text)) {
      messages.remove(messages.last);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message could not send'),
        ),
      );
    }
  }

  _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100), 
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    message.addListener(() {
      setState(() { });
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(user2),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty ?
              Text(
                "Be the first to send a message!",
                style: Theme.of(context).textTheme.titleMedium,
              ) :
              SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  // key: const ValueKey(1),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages[index];
                  },
                ),
              ),
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.centerEnd,
            children: [
              Expanded(
                child: TextField(
                  // onChanged: (newMessage) {
                  //   _onMessageChange(newMessage);
                  // },
                  controller: message,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: "message...",
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                iconSize: 24.0,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => _sendMessage(),
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
          SizedBox(width: w/15 + 10),
          const Spacer(),
          Container(
            constraints: BoxConstraints(
              maxWidth: w - (w/15)*2 - 50,
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          const SizedBox(width: 5.0),
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
          const SizedBox(width: 5.0),
          Container(
            constraints: BoxConstraints(
              maxWidth: w - (w/15)*2 - 50,
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(width: w/15 + 10),
        ],
      );
    }
  }
}