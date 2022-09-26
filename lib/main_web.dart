import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';

void main() {
  runApp(const App());
}

const darkBackgroundColor = Color(0xff304349);
final backgroundColor = Colors.green.shade50;

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
          final fontFamily =
              kIsWeb && window.navigator.userAgent.contains('OS 15_')
                  ? '-apple-system'
                  : null;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueGrey,
              ),
              backgroundColor: backgroundColor,
              scaffoldBackgroundColor: backgroundColor,
              //https://github.com/flutter/flutter/issues/93140
              fontFamily: fontFamily,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              backgroundColor: darkBackgroundColor,
              scaffoldBackgroundColor: darkBackgroundColor,
              //https://github.com/flutter/flutter/issues/93140
              fontFamily: fontFamily,
            ),
            themeMode:
                value == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      );
}
