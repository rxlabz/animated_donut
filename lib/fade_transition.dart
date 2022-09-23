import 'package:flutter/material.dart';

Widget fadeTransitionBuilder(context, animation, secondaryAnimation, child) {
  var fadeIn = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      curve: const Interval(.8, 1),
      parent: animation,
    ),
  );
  var fadeOut = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      curve: const Interval(0, .1),
      parent: animation,
    ),
  );
  return Stack(
    children: <Widget>[
      FadeTransition(
        opacity: fadeOut,
        child: Container(color: Colors.white),
      ),
      FadeTransition(opacity: fadeIn, child: child)
    ],
  );
}
