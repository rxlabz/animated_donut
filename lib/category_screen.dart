import 'package:flutter/material.dart';

import 'chart_view.dart';
import 'fade_transition.dart';
import 'model.dart';
import 'segment_helpers.dart';
import 'subcategories_screen.dart';

class CategoryScreen extends StatelessWidget {
  final List<Category> categories;

  const CategoryScreen({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Donut', style: textTheme.displayMedium),
          ),
          Flexible(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(graphSize),
                child: CategoryDonutHero(categories: categories),
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FractionColumnWidth(.1),
                    1: FractionColumnWidth(.5),
                    2: FractionColumnWidth(.4),
                  },
                  children: categories
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
            ),
          )
        ],
      ),
    );
  }
}

class CategoryDonutHero extends StatefulWidget {
  final List<Category> categories;

  const CategoryDonutHero({required this.categories, super.key});

  @override
  State<CategoryDonutHero> createState() => _CategoryDonutHeroState();
}

class _CategoryDonutHeroState extends State<CategoryDonutHero>
    with TickerProviderStateMixin {
  late final anim = AnimationController(vsync: this, duration: donutDuration);

  int? selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    anim.forward();
  }

  @override
  void dispose() {
    super.dispose();
    anim.dispose();
  }

  @override
  Widget build(BuildContext context) => Hero(
        tag: 'donut',
        flightShuttleBuilder: buildTransitionHero,
        child: ChartView(
          key: ValueKey(widget.categories),
          transitionProgress: 0,
          onSelection: (newIndex) {
            setState(() => selectedCategoryIndex = newIndex);
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => SubCategoryScreen(
                  category: widget.categories[newIndex],
                ),
                reverseTransitionDuration: donutDuration,
                transitionsBuilder: fadeTransitionBuilder,
                transitionDuration: donutDuration,
              ),
            );
          },
          categories: widget.categories,
          segments: computeSegments(widget.categories),
          intervals: computeSegmentIntervals(
            categories: widget.categories,
            anim: anim,
          ),
          anim: anim,
        ),
      );

  Widget buildTransitionHero(
    BuildContext context,
    Animation<double> heroAnim,
    HeroFlightDirection direction,
    BuildContext fromContext,
    BuildContext toContext,
  ) =>
      AnimatedBuilder(
        animation: heroAnim,
        builder: (context, _) => AspectRatio(
          aspectRatio: 1,
          child: ChartView(
            key: const Key('transition-donut'),
            selectedIndex: selectedCategoryIndex,
            transitionProgress: heroAnim.value,
            onSelection: (newIndex) {},
            categories: widget.categories,
            segments: computeSegments(widget.categories),
            intervals: computeSegmentIntervals(
              categories: widget.categories,
              anim: anim,
            ),
            anim: AnimationController(
              vsync: this,
              duration: donutDuration,
            ),
          ),
        ),
      );
}
