import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/group.dart';
import 'package:ram/models/messagelist.dart';
import 'package:ram/models/user.dart';
import 'package:ram/models/message.dart';

class Chat extends StatefulWidget {
  const Chat(this.friend, this.group, {Key? key}) : super(key: key);

  final User friend;
  final Group group;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: true,
  );

  TextEditingController message = TextEditingController();

  final MessageList messages = MessageList();

  _sendMessage() async {
    if (message.text.isEmpty) return;

    final text = message.text;
    // message.text = "";
    messages.addMessage(Message(text, context.read<User>().uid, context.read<User>().username, context.read<User>().profile));
    _scrollToBottom();

    if (!await context.read<User>().sendMessage(widget.friend.uid, widget.group.getID, text)) {
      messages.removeMessage();
      setState(() { });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message could not send'),
          ),
        );
      }
    }
  }

  _refreshMessages() async {
    await messages.getMessages(context.read<User>().uid, widget.friend.uid, widget.group.getID.toString());
    setState(() { }); // use ChangeNotifier instead of this empty setstate stuff
  }

  _scrollToBottom() {
    if (!messages.isEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), 
        curve: Curves.ease,
      );
    }
  }

  @override
  void initState() {
    message.addListener(() {
      setState(() { });
    });
    _refreshMessages();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    message.dispose();
    messages.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        title: widget.friend.uid != "0" ? Text(widget.friend.username) : Text(widget.group.getName),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty ?
              Center(
                child: Text(
                  "Be the first to send a message!",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ) :
              // CustomRefreshIndicator(
              //   onRefresh: () => getNewMessages(),
              //   trigger: IndicatorTrigger.trailingEdge,
              //   trailingScrollIndicatorVisible: false,
              //   leadingScrollIndicatorVisible: true,
              //   builder: (BuildContext context, Widget child, IndicatorController controller) {
              //     return const Loader();
              //   },
              SingleChildScrollView(
                controller: _scrollController,
                child: ListView.builder(
                  // key: const ValueKey(1),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages.at(index);
                  },
                ),
              ),
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.centerEnd,
            children: [
              TextField(
                // onChanged: (newMessage) {
                //   _onMessageChange(newMessage);
                // },
                controller: message,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: "message...",
                  fillColor: Theme.of(context).colorScheme.tertiary,
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