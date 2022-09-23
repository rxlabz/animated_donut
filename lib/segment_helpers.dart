import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'model.dart';

List<SegmentData> computeSegments<T extends AbstractCategory>(
  List<T> categories,
) {
  // calcul des angles des ≠ segments
  return enumerate(categories).fold<List<SegmentData>>(<SegmentData>[],
      (previousValue, category) {
    if (previousValue.isEmpty) {
      final elementSweepAngle =
          category.value.total / categories.total * 2 * math.pi;

      return [
        SegmentData(
          title: category.value.title,
          subtitle: '${category.value.total.toStringAsFixed(2)}€',
          startAngle: -math.pi / 2,
          sweepAngle: elementSweepAngle,
          color: category.value.color,
        )
      ];
    }
    final previousElement = previousValue.last;

    final elementSweepAngle =
        category.value.total / categories.total * 2 * math.pi;

    return previousValue
      ..add(
        SegmentData(
          title: category.value.title,
          subtitle: '${category.value.total.toStringAsFixed(2)}€',
          startAngle: previousElement.startAngle + previousElement.sweepAngle,
          sweepAngle: elementSweepAngle,
          color: category.value.color,
        ),
      );
  });
}

List<Animation> computeSegmentIntervals({
  required AnimationController anim,
  required List<AbstractCategory> categories,
}) {
  final intervalValues = <List<double>>[];
  final intervals = <CurvedAnimation>[];

  for (final category in enumerate(categories)) {
    if (category.index == 0) {
      final end = category.value.total / categories.total;
      final interval = CurvedAnimation(parent: anim, curve: Interval(0, end));
      intervals.add(interval);
      intervalValues.add([0, end]);
      continue;
    }
    final end = category.value.total / categories.total;
    final previousInterval = intervalValues.last;
    final interval = CurvedAnimation(
      parent: anim,
      curve: Interval(previousInterval.last, previousInterval.last + end),
    );
    intervals.add(interval);
    intervalValues.add([previousInterval.last, previousInterval.last + end]);
  }

  return intervals;
}
