import 'dart:math';

import 'package:flutter/painting.dart';

class SegmentData {
  final String title;
  final String subtitle;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  const SegmentData({
    required this.title,
    required this.subtitle,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  factory SegmentData.fill({
    required Color color,
    String title = '',
    String subtitle = '',
  })=> SegmentData(
    title: title,
    startAngle: pi / 2,
    sweepAngle: 2 * pi,
    color: color,
    subtitle: subtitle,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SegmentData &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              startAngle == other.startAngle &&
              sweepAngle == other.sweepAngle &&
              color == other.color;

  @override
  int get hashCode =>
      title.hashCode ^
      startAngle.hashCode ^
      sweepAngle.hashCode ^
      color.hashCode;
}
