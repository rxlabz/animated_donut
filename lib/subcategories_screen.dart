import 'dart:math';

import 'package:flutter/material.dart';

import 'chart_view.dart';
import 'model.dart';
import 'segment_helpers.dart';

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
  late final stoppedAnim = AnimationController(
      vsync: this, duration: const Duration(seconds: 1), value: 1);

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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(widget.category.title, style: textTheme.displaySmall),
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(graphSize),
                child: Stack(
                  children: [
                    _buildBackgroundChart(),
                    Hero(
                      tag: 'donut',
                      child: ChartView(
                        key: ValueKey(widget.subCategories),
                        segments: computeSegments(widget.subCategories),
                        intervals: computeSegmentIntervals(
                          categories: widget.subCategories,
                          anim: anim,
                        ),
                        anim: anim,
                        transitionProgress: 0,
                        onSelection: (int value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Padding(
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: e.color,
                                width: 32,
                                height: 32,
                              ),
                            ),
                            Text(e.title),
                            Text('${e.total.toStringAsFixed(2)}€')
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// background full circle
  ChartView _buildBackgroundChart() => ChartView(
        key: ValueKey(widget.category),
        segments: [
          SegmentData(
            title: '',
            startAngle: pi / 2,
            sweepAngle: 2 * pi,
            color: widget.category.color,
            subtitle: '',
          )
        ],
        selectedIndex:0,
        intervals: [
          CurvedAnimation(
            parent: stoppedAnim,
            curve: Curves.linear,
          ),
        ],
        anim: stoppedAnim,
        transitionProgress: 1,
        onSelection: (int value) {},
      );
}
