import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart' as qv;

import 'data.dart';
import 'donut/segment_helpers.dart';
import 'donut/segment_paint.dart';
import 'model.dart';
import 'tables.dart';

void main() {
  runApp(App(categories));
}

const backgroundColor = Color(0xff304349);

class App extends StatelessWidget {
  final List<Category> categories;

  const App(this.categories, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark().copyWith(
          backgroundColor: backgroundColor,
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: SliverCategoryScreen(categories: categories),
      );
}

class SectionNotification extends Notification {
  final int index;

  SectionNotification(this.index);
}

class SliverCategoryScreen extends StatelessWidget {
  final List<Category> categories;

  final ValueNotifier<int> selectedSectionIndex = ValueNotifier(0);

  SliverCategoryScreen({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SectionNotification>(
      onNotification: (notification) {
        Future.microtask(() => selectedSectionIndex.value = notification.index);
        return false;
      },
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: selectedSectionIndex,
          builder: (context, sectionIndex, _) {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    backgroundColor: Colors.black12,
                    pinned: false,
                    floating: false,
                    expandedHeight: 180,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Donut',
                        style: TextStyle(color: Colors.limeAccent),
                      ),
                      expandedTitleScale: 2,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    sliver: SliverPersistentHeader(
                      pinned: sectionIndex == 0,
                      delegate: StickyChartHeaderDelegate(
                        index: 0,
                        color: Colors.limeAccent,
                        showLight: true,
                        title: 'Global',
                        categories: categories,
                        minHeight: 64,
                        maxHeight: 280,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CategoriesTable(
                      categories: categories,
                      selectable: false,
                      onSelection: (category) {},
                    ),
                  ),
                  for (final category in qv.enumerate(categories)) ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      sliver: SliverPersistentHeader(
                        pinned: category.index + 1 >= sectionIndex,
                        delegate: StickyChartHeaderDelegate(
                          index: category.index + 1,
                          color: category.value.color,
                          title: category.value.title,
                          categories: category.value.subCategories,
                          minHeight: 64,
                          maxHeight: 300,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        category.value.subCategories
                            .map(
                              (subCategory) => ListTile(
                                title: Text(subCategory.title),
                                subtitle: Text(
                                    '${subCategory.operations.length} operations'),
                                trailing: Text(
                                  '${subCategory.total}€',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: category.value.color),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class StickyChartHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int index;
  final String title;
  final Color color;

  final List<AbstractCategory> categories;

  final double minHeight;
  final double maxHeight;
  final bool showLight;

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  StickyChartHeaderDelegate({
    required this.index,
    required this.title,
    required this.color,
    required this.categories,
    required this.minHeight,
    required this.maxHeight,
    this.showLight = false,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final textTheme = Theme.of(context).textTheme;
    if (overlapsContent && shrinkOffset >= 1) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SectionNotification(index).dispatch(context);
      });
    }

    // qd visible à nouveau => on pin la catégory précédente
    if (shrinkOffset == 0 && index > 0) {
      SectionNotification(index - 1).dispatch(context);
    }

    return Container(
      color: backgroundColor,
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: textTheme.titleLarge?.copyWith(color: color),
            ),
          ),
          shrinkOffset > maxHeight - minHeight
              ? Flexible(
                  child: BarChart(
                    categories: categories,
                    showLight: showLight,
                    progress:
                        (shrinkOffset - (maxHeight - minHeight)) / minHeight,
                  ),
                )
              : Flexible(
                  child: Center(
                    child: DonutChart(
                      categories: categories,
                      radiusFactor:
                          1 - max(shrinkOffset, 1) / (maxHeight - minHeight),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(StickyChartHeaderDelegate oldDelegate) =>
      oldDelegate.minHeight != minHeight || oldDelegate.maxHeight != maxHeight;
}

class DonutChart extends StatelessWidget {
  final List<AbstractCategory> categories;

  ///  circle [1 -> 0] square
  final double radiusFactor;

  const DonutChart({
    required this.categories,
    required this.radiusFactor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          size: graphSize,
          painter: DonutPainter(categories, radiusFactor),
        ),
      );
}

class DonutPainter extends CustomPainter {
  final List<AbstractCategory> categories;

  final double radiusFactor;

  DonutPainter(this.categories, this.radiusFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    canvas.clipPath(
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCircle(center: center, radius: size.height / 2),
            Radius.circular(radiusFactor * size.height / 2),
          ),
        )
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCircle(
              center: center,
              radius: size.height / (4 + (8 * (1 - radiusFactor))),
            ),
            Radius.circular(radiusFactor * size.height / 4),
          ),
        )
        ..fillType = PathFillType.evenOdd,
    );

    final arcs = computeArcs(categories);

    final shadowPaint = Paint()
      ..blendMode = BlendMode.overlay
      ..shader = ui.Gradient.radial(
        size.center(Offset.zero),
        size.width / 2,
        [
          Colors.black26,
          Colors.white24,
        ],
        [0.4, 1],
      );

    for (final segment in arcs) {
      final center = size.center(Offset.zero);
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.lineTo(center.dx, 30);
      path.addArc(
        Rect.fromCircle(center: center, radius: size.height / 2 + 30),
        segment.startAngle - pi * (1 - radiusFactor),
        segment.sweepAngle,
      );
      path.lineTo(center.dx, center.dy);
      canvas.drawPath(path, Paint()..color = segment.color);

      canvas.drawPath(path, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BarChart extends StatelessWidget {
  final List<AbstractCategory> categories;
  final double progress;
  final bool showLight;

  const BarChart({
    required this.categories,
    required this.progress,
    required this.showLight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * max(.1, progress),
        child: Container(
          color: Colors.pink,
          child: CustomPaint(
            size: Size(size.width * progress, 48),
            painter: BarChartPainter(categories, progress),
          ),
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<AbstractCategory> categories;
  final double progress;
  final bool showLight;

  BarChartPainter(this.categories, this.progress, [this.showLight = false]);

  @override
  void paint(Canvas canvas, Size size) {
    final segments = computeSegments(categories);

    for (final segment in segments) {
      final rect = Rect.fromPoints(
        Offset(segment.start.dx * size.width, 0),
        Offset(
          (segment.start.dx + segment.width.dx) * size.width,
          size.height,
        ),
      );
      canvas.drawRect(rect, Paint()..color = segment.color);

      if (showLight) {
        final gradientPaint = Paint()
          ..shader = ui.Gradient.linear(
            Offset.zero,
            size.bottomLeft(Offset.zero),
            [Colors.transparent, Colors.black38],
          );
        canvas.drawRect(
          rect,
          gradientPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
