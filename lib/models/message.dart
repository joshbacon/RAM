import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/models/user.dart';
import 'package:ram/pages/profile.dart';

class Message extends StatelessWidget {
  const Message(this.message, this.senderID, this.senderName, this.profileImage, {Key? key}) : super(key: key);

  // pull in a user instead of just sender and the profile image, then uncomment navigation command

  final String message;
  final String senderID;
  final String senderName;
  final dynamic profileImage;

  Future<void> showProfile(context, user) async {
    final author = await user(senderID);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(author)));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (senderID == context.read<User>().uid) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Row(
          children: [
            const Spacer(),
            Container(
              constraints: BoxConstraints(
                maxWidth: w - (w/15)*2 - 65,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
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
                showProfile(context, context.read<User>().getUserInfo);
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
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
            const SizedBox(width: 10.0),
            Text(
              senderName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(69)
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    }
  }
}