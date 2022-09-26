import 'package:flutter/material.dart';

import 'category_screen.dart';
import 'data.dart';
import 'sliver_donut_example.dart';

ValueNotifier<Brightness> brightness = ValueNotifier(Brightness.dark);

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Donuts'),
        actions: [
          if (brightness.value != Brightness.light)
            IconButton(
              onPressed: () => brightness.value = Brightness.light,
              icon: const Icon(Icons.light_mode_outlined),
            ),
          if (brightness.value != Brightness.dark)
            IconButton(
              onPressed: () => brightness.value = Brightness.dark,
              icon: const Icon(Icons.dark_mode_rounded),
            )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.layers_outlined),
            title: const Text('Animated Donut Hero transition'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoryScreen(categories: categories),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: const Text('Sliver persistent Donut header delegate'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    SliverCategoryScreen(categories: categories),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
