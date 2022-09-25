import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../model.dart';
import 'segment_data.dart';

List<ArcData> computeArcs(List<AbstractCategory> categories) =>
    enumerate(categories).fold<List<ArcData>>(
      <ArcData>[],
      (previousValue, category) {
        final elementSweepAngle =
            category.value.total / categories.total * 2 * math.pi;

        if (previousValue.isEmpty) {
          return [
            ArcData(
              title: category.value.title,
              subtitle: '${category.value.total.toStringAsFixed(2)}€',
              startAngle: -math.pi / 2,
              sweepAngle: elementSweepAngle,
              color: category.value.color,
            )
          ];
        }

        final previousElement = previousValue.last;
        return previousValue
          ..add(
            ArcData(
              title: category.value.title,
              subtitle: '${category.value.total.toStringAsFixed(2)}€',
              startAngle:
                  previousElement.startAngle + previousElement.sweepAngle,
              sweepAngle: elementSweepAngle,
              color: category.value.color,
            ),
          );
      },
    );

List<SegmentData> computeSegments(List<AbstractCategory> categories) =>
    enumerate(categories).fold<List<SegmentData>>(
      <SegmentData>[],
      (previousValue, category) {
        final elementWidth =
            FractionalOffset(category.value.total / categories.total, 0);

        if (previousValue.isEmpty) {
          return [
            SegmentData(
              title: category.value.title,
              subtitle: '${category.value.total.toStringAsFixed(2)}€',
              start: const FractionalOffset(0, 0),
              width: elementWidth,
              color: category.value.color,
            )
          ];
        }

        final previousElement = previousValue.last;
        return previousValue
          ..add(
            SegmentData(
              title: category.value.title,
              subtitle: '${category.value.total.toStringAsFixed(2)}€',
              start: FractionalOffset(
                previousElement.start.dx + previousElement.width.dx,
                0,
              ),
              width: elementWidth,
              color: category.value.color,
            ),
          );
      },
    );

List<Animation> computeArcIntervals({
  required Animation<double> anim,
  required List<AbstractCategory> categories,
}) {
  final intervalValues = <List<double>>[];
  final intervals = <Animation>[];

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
