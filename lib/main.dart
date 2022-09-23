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
        home: CategoryScreen(categories: categories),
      );
}
