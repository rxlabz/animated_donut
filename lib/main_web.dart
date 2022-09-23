import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'category_screen.dart';
import 'data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      //https://github.com/flutter/flutter/issues/93140
      fontFamily: kIsWeb && window.navigator.userAgent.contains('OS 15_')
          ? '-apple-system'
          : null,
    ),
        home: CategoryScreen(categories: categories),
      );
}
