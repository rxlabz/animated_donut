import 'dart:math';

import 'package:flutter/material.dart';

import 'chart_view.dart';
import 'model.dart';
import 'segment_paint.dart';
import 'ui.dart';

class SubCategoryScreen extends StatefulWidget {
  final Category category;

  List<SubCategory> get subCategories => category.subCategories;

  const SubCategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen>
    with TickerProviderStateMixin {
  late final anim =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    Future.delayed(
      donutDuration,
      () => anim
        ..reset()
        ..forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.category.title,
          style: TextStyle(color: widget.category.color),
        ),
        leading: BackButton(color: widget.category.color),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              constraints: BoxConstraints.loose(graphSize),
              child: Stack(
                children: [
                  _DonutBackground(
                    widget.category.color,
                    key: ValueKey(widget.category.color),
                  ),
                  Hero(
                    tag: 'donut',
                    child: ChartView(
                      key: ValueKey(widget.subCategories),
                      categories: widget.subCategories,
                      animation: anim,
                      transitionProgress: 0,
                      onSelection: (int value) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          _SubCategoriesTable(widget: widget)
        ],
      ),
    );
  }
}

class _SubCategoriesTable extends StatelessWidget {
  const _SubCategoriesTable({Key? key, required this.widget}) : super(key: key);

  final SubCategoryScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FractionColumnWidth(.1),
          1: FractionColumnWidth(.5),
          2: FractionColumnWidth(.4),
        },
        children: widget.subCategories
            .map(
              (e) => TableRow(
                decoration: tableDecoration,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(color: e.color, height: 24),
                  ),
                  Text(e.title),
                  Text('${e.total.toStringAsFixed(2)}€')
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DonutBackground extends StatelessWidget {
  final Color color;

  const _DonutBackground(this.color, {super.key});

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.fill,
        child: DonutSegmentPaint(
          key: const Key('donut'),
          SegmentData(
            title: '',
            startAngle: pi / 2,
            sweepAngle: 2 * pi,
            color: color,
            subtitle: '',
          ),
          progress: 1,
          transitionProgress: 1,
          onSelection: () {},
        ),
      );
}
