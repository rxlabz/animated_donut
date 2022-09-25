import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      fold(0.0, (previousValue, category) => previousValue + category.total);
}

class Category extends AbstractCategory {
  final List<SubCategory> _subCategories;
  List<SubCategory> get subCategories => List.unmodifiable(_subCategories);

  @override
  double get total => _subCategories.total;

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
      operations.reduce((previousValue, element) => previousValue + element);

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
