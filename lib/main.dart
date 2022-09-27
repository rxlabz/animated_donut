import 'package:flutter/material.dart';

import 'main_screen.dart';

void main() {
  runApp(const App());
}

final backgroundColor = Colors.green.shade50;
const darkBackgroundColor = Color(0xff304349);
const darkerBackgroundColor = Color(0xff26393d);

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: brightness,
        builder: (context, value, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueGrey,
              ),
              backgroundColor: backgroundColor,
              scaffoldBackgroundColor: backgroundColor,
            ),
            darkTheme: ThemeData.dark().copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: darkerBackgroundColor,
                foregroundColor: Colors.blueGrey.shade300,
              ),
              backgroundColor: darkBackgroundColor,
              scaffoldBackgroundColor: darkBackgroundColor,
            ),
            themeMode:
                value == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      );
}
