import 'package:flutter/material.dart';

import 'donut/chart_view.dart';
import 'donut/segment_data.dart';
import 'donut/segment_paint.dart';
import 'model.dart';
import 'tables.dart';

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
          SubCategoriesTable(subCategories: widget.subCategories)
        ],
      ),
    );
  }
}

class _DonutBackground extends StatelessWidget {
  final Color color;

  const _DonutBackground(this.color, {super.key});

  @override
  Widget build(BuildContext context) => DonutSegment(
        key: const Key('donut'),
        data: ArcData.fill(color: color),
        progress: 1,
        transitionProgress: 1,
        onSelection: () {},
      );
}
