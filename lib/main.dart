import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/login.dart';
import 'package:ram/models/user.dart';
import 'package:ram/models/postlist.dart';
//import 'package:ram/pages/nav.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User.asNull()),
      ],
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'RAM',
      home: LoginPage(),
    );
  }
}
