/*

  This widget is displayed at the top of the home page;
  Make updates here when there is news for the user

*/


import 'package:flutter/material.dart';


class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
      child: Text(
        "welcome to the app!\ni am implementing a testing process named TIP (test in production) so submit a bug here if something doesn't work",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1,
        ),
      ),
    );
  }
}