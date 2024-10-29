/*

  This widget is displayed at the top of the home page;
  Make updates here when there is news for the user

*/


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  Future<void> enterBug() async {
    try {
      await launchUrl(Uri.parse('https://github.com/joshbacon/ram/issues/new'));
      // await launch('https://github.com/joshbacon/ram/issues/new');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
          child: Text(
            "Welcome to the app!\nI'm implementing a testing process named TIP (test in production)",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1,
            ),
          ),
        ),
        Center(
          child: InkWell(
            child: Text(
              "submit a bug",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                height: 1,
              ),
            ),
            onTap: () => enterBug(),
          )
        )
      ],
    );
  }
}