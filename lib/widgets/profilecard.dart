import 'package:flutter/material.dart';
import '../models/user.dart';
import '../pages/profile.dart';

class ProfileCard extends StatefulWidget {
  
  const ProfileCard({Key? key}) : super(key: key);
  // const ProfileCard(this.user, {Key? key}) : super(key: key);

  // final User user;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

  Map<String, dynamic> userData = {
    "uid": "1",
    "username": "Bacon",
    "joinedat": "null",
    "profile": const AssetImage('assets/defaultProfile.png'),
    "banner": const AssetImage('assets/defaultBanner.png')
  };

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w * 0.8,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.background,
        elevation: 10,
        child: Stack(
          children: [
            InkWell(
              splashColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      User(userData)
                    )
                  )
                );
              },
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image(
                        image: userData['banner'],
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: CircleAvatar(
                          radius: w/10,
                          backgroundColor: Theme.of(context).colorScheme.background,
                          backgroundImage: userData['profile'],
                        )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        userData['username'],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Spacer(flex: 1),
                      IconButton(
                        onPressed: () {},
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
            ),
          ]
        ),
      ),
    );
  }
}