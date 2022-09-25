import 'dart:math';

import 'package:flutter/painting.dart';

class SegmentData {
  final String title;
  final String subtitle;
  final FractionalOffset start;
  final FractionalOffset width;
  final Color color;

  const SegmentData({
    required this.title,
    required this.subtitle,
    required this.start,
    required this.width,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SegmentData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          subtitle == other.subtitle &&
          start == other.start &&
          width == other.width &&
          color == other.color;

  @override
  int get hashCode =>
      title.hashCode ^
      subtitle.hashCode ^
      start.hashCode ^
      width.hashCode ^
      color.hashCode;

  @override
  String toString() => 'SegmentData{title: $title, subtitle: $subtitle, '
      'start: $start, width: $width, color: $color}';
}

class ArcData {
  final String title;
  final String subtitle;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  const ArcData({
    required this.title,
    required this.subtitle,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  factory ArcData.fill({
    required Color color,
    String title = '',
    String subtitle = '',
  }) =>
      ArcData(
        title: title,
        startAngle: pi / 2,
        sweepAngle: 2 * pi,
        color: color,
        subtitle: subtitle,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArcData &&
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

  @override
  String toString() =>
      'ArcData{title: $title, subtitle: $subtitle, startAngle: $startAngle,'
      ' sweepAngle: $sweepAngle, color: $color}';
}
