import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/group.dart';
import 'package:ram/models/user.dart';
import 'package:ram/pages/profile.dart';

class Message extends StatelessWidget {
  const Message(this.message, this.sender, this.profileImage, {Key? key}) : super(key: key);

  // pull in a user instead of just sender and the profile image, then uncomment navigation command

  final String message;
  final String sender;
  final dynamic profileImage;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (sender == context.read<User>().uid) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          children: [
            const Spacer(),
            Container(
              constraints: BoxConstraints(
                maxWidth: w - (w/15)*2 - 65,
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
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(width: 10.0),
            CircleAvatar(
              radius: w/15,
              backgroundColor: Theme.of(context).colorScheme.background,
              backgroundImage: profileImage,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(widget.user)));
              },
              child: CircleAvatar(
                radius: w/15,
                backgroundColor: Theme.of(context).colorScheme.background,
                backgroundImage: profileImage,
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              constraints: BoxConstraints(
                maxWidth: w - (w/15)*2 - 65,
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
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    }
  }
}