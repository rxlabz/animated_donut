import 'package:flutter/material.dart';

import 'model.dart';

final tableDecoration = BoxDecoration(
  color: Colors.green.shade200.withOpacity(.3),
  borderRadius: BorderRadius.circular(6),
  border: Border.all(color: Colors.white, width: 1),
);

final darkTableDecoration = BoxDecoration(
  color: Colors.grey.shade900.withOpacity(.3),
  borderRadius: BorderRadius.circular(6),
  border: Border.all(color: Colors.transparent, width: 1),
);

class CategoriesTable extends StatelessWidget {
  final List<Category> categories;

  final bool selectable;

  final ValueChanged<Category> onSelection;

  const CategoriesTable({
    Key? key,
    required this.categories,
    required this.onSelection,
    this.selectable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = theme.brightness == Brightness.light
        ? tableDecoration
        : darkTableDecoration;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: const FractionColumnWidth(.1),
          1: FractionColumnWidth(selectable ? .4 : .6),
          2: const FractionColumnWidth(.3),
          if (selectable) 3: const FractionColumnWidth(.2),
        },
        children: categories
            .map((c) => _buildRow(c, decoration: decoration))
            .toList(),
      ),
    );
  }

  TableRow _buildRow(Category category, {required BoxDecoration decoration}) =>
      TableRow(
        decoration: decoration,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(color: category.color, height: 24),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(category.title),
          ),
          Text('${category.total.toStringAsFixed(2)}€'),
          if (selectable)
            IconButton(
              onPressed: () => onSelection(category),
              hoverColor: Colors.cyan.shade100,
              color: Colors.cyan.shade700,
              padding: const EdgeInsets.all(10),
              splashRadius: 18,
              icon: const Icon(Icons.zoom_in),
            ),
        ],
      );
}

class SubCategoriesTable extends StatelessWidget {
  final List<SubCategory> subCategories;

  const SubCategoriesTable({Key? key, required this.subCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final decoration = theme.brightness == Brightness.light
        ? tableDecoration
        : darkTableDecoration;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FractionColumnWidth(.1),
          1: FractionColumnWidth(.5),
          2: FractionColumnWidth(.4),
        },
        children: subCategories
            .map((e) => _buildRow(subCategory: e, decoration: decoration))
            .toList(),
      ),
    );
  }

  TableRow _buildRow({
    required SubCategory subCategory,
    required BoxDecoration decoration,
  }) =>
      TableRow(
        decoration: decoration,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(color: subCategory.color, height: 24),
          ),
          Text(subCategory.title),
          Text('${subCategory.total.toStringAsFixed(2)}€')
        ],
      );
}
