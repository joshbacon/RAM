import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ram/pages/login.dart';
import 'package:ram/models/user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
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

  static const Color orange = Color.fromRGBO(255, 163, 0, 1.0);
  static const Color red = Color.fromRGBO(170, 0, 0, 1.0);
  static const Color darkGrey = Color.fromRGBO(49, 49, 49, 1.0);
  static const Color lightGrey = Color.fromARGB(255, 69, 69, 69);
  static const Color middleGrey = Color.fromRGBO(91, 91, 91, 1.0);
  static const Color darkishLightGrey = Color.fromARGB(255, 56, 56, 56);
  static const Color offWhite = Color.fromARGB(255, 230, 230, 230);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAM',
      home: const LoginPage(),
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: orange,
          onPrimary: offWhite,
          secondary: red,
          onSecondary: offWhite,
          error: Colors.red,
          onError: offWhite,
          background: darkGrey,
          onBackground: offWhite,
          tertiary: lightGrey,
          surface: middleGrey,
          onSurface: orange
        ),

        fontFamily: "dubai",
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontFamily: "dubai",
            decoration: TextDecoration.underline,
            color: orange,
            fontSize: 28,
            height: 1,
          ),
          titleSmall: TextStyle(
            fontFamily: "dubai",
            decoration: TextDecoration.none,
            color: orange,
            fontSize: 21,
          ),
          bodyLarge: TextStyle(
            fontFamily: "dubai",
            decoration: TextDecoration.none,
            color: offWhite,
            fontSize: 30,
            height: 1,
          ),
          bodyMedium: TextStyle(
            fontFamily: "dubai",
            decoration: TextDecoration.none,
            color: offWhite,
            fontSize: 20,
          ),
          bodySmall: TextStyle(
            fontFamily: "dubai",
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          displaySmall: TextStyle(
            fontFamily: "dubai",
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )
        ),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(91, 91, 91, 1.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: orange),
          ),
          hintStyle: TextStyle(
            fontFamily: "dubai",
            color: Color.fromARGB(255, 223, 223, 223),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(91, 91, 91, 1.0),
          unselectedItemColor: orange,
          selectedItemColor: offWhite,
          elevation: 1,
        ),

        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color.fromRGBO(91, 91, 91, 1.0),
        )
      ),
    );
  }
}