import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/group.dart';
import 'package:ram/models/user.dart';
import 'package:ram/pages/chat.dart';

class GroupCard extends StatefulWidget {
  
  const GroupCard(this.group, {Key? key}) : super(key: key);

  final Group group;

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {

  List<User> participants = [];

  void loadParticipants() async {
    List<User> loadedUsers = await widget.group.getParticipants(context.read<User>().uid);
    loadedUsers.shuffle();
    setState(() {
      participants = loadedUsers;
    });
  }

  @override
  void initState() {
    loadParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w * 0.8,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.tertiary,
        elevation: 10,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  child: SizedBox(
                    width: w*0.8,
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: participants.length,
                      itemBuilder: ((context, index) => CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        backgroundImage: participants[index].profile,
                      )),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      widget.group.getName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(flex: 1),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(User.asNull(), widget.group)));
                      },
                      highlightColor: const Color.fromARGB(0, 255, 255, 255),
                      splashColor: Theme.of(context).colorScheme.primary.withAlpha(127),
                      splashRadius: 40,
                      icon: Icon(
                        Icons.chat,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}