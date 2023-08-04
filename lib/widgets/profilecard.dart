import 'dart:ffi';

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
        color: const Color.fromRGBO(49, 49, 49, 1.0),
        elevation: 10,
        child: Stack(
          children: [
            InkWell(
              splashColor: const Color.fromRGBO(255, 163, 0, 1.0),
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
                          backgroundColor: const Color.fromRGBO(49, 49, 49, 1.0),
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
                        style: const TextStyle(
                          fontFamily: "dubai",
                          decoration: TextDecoration.none,
                          color: Color.fromRGBO(255, 163, 0, 1.0),
                          fontSize: 21,
                          height: 1,
                        ),
                      ),
                      const Spacer(flex: 1),
                      IconButton(
                        onPressed: () {},
                        highlightColor: const Color.fromARGB(0, 255, 255, 255),
                        splashColor: const Color.fromRGBO(255, 163, 0, 0.5),
                        splashRadius: 40,
                        icon: const Icon(
                          Icons.chat,
                          size: 30,
                          color: Color.fromRGBO(255, 163, 0, 1.0),
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