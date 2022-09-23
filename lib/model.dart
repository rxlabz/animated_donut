import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const graphSize = Size(300, 300);

class TooltipNotification extends Notification {
  final Offset? position;
  final String? title;
  final String? subtitle;
  final Color? color;

  final bool hide;

  TooltipNotification({
    this.position,
    this.title,
    this.subtitle,
    this.color,
  }) : hide = false;

  TooltipNotification.hide()
      : hide = true,
        position = null,
        subtitle = null,
        color = null,
        title = null;
}

abstract class AbstractCategory {
  final String _title;
  String get title => _title;

  final Color _color;
  Color get color => _color;

  double get total;

  AbstractCategory(this._title, this._color);
}

extension CategoryListExtensions on List<AbstractCategory> {
  double get total =>
      fold(0.0, (previousValue, element) => previousValue + element.total);
}

class Category extends AbstractCategory {
  final List<SubCategory> _subCategories;
  List<SubCategory> get subCategories => List.unmodifiable(_subCategories);

  @override
  double get total => subCategories.fold(
      0.0,
      (previousValue, element) => previousValue + element.operations
          .fold(0.0, (previousValue, element) => previousValue + element));

  Category({
    required String title,
    required Color color,
    required List<SubCategory> subCategories,
  })  : _subCategories = subCategories,
        super(title, color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          color == other.color &&
          listEquals(subCategories, other.subCategories);

  @override
  int get hashCode => title.hashCode ^ color.hashCode ^ subCategories.hashCode;
}

class SubCategory extends AbstractCategory {
  final List<double> operations;

  @override
  double get total =>
      operations.fold(0.0, (previousValue, element) => previousValue + element);

  SubCategory({
    required String title,
    required Color color,
    required this.operations,
  }) : super(title, color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategory &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          color == other.color &&
          listEquals(operations, other.operations);

  @override
  int get hashCode => title.hashCode ^ color.hashCode ^ operations.hashCode;
}

class SegmentData {
  final String title;
  final String subtitle;
  final double startAngle;
  final double sweepAngle;
  final Color color;

  SegmentData({
    required this.title,
    required this.subtitle,
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

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
