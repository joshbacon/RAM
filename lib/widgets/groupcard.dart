import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/group.dart';
import 'package:ram/models/user.dart';
import 'package:ram/pages/chat.dart';
import 'package:ram/widgets/loader.dart';

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
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(User.asNull(), widget.group)));
        },
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
                      child: participants.isNotEmpty ?
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: participants.length,
                          itemBuilder: ((context, index) => CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            backgroundImage: participants[index].profile,
                          )),
                        ) : const Loader(),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          widget.group.getName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}