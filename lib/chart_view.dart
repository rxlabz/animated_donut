import 'package:basics/int_basics.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'model.dart';
import 'segment_paint.dart';

const donutDuration = Duration(seconds: 1);

class ChartView extends StatelessWidget {
  final List<Category>? categories;
  final List<Animation> intervals;
  final List<SegmentData> segments;
  final AnimationController anim;

  final Category? selectedCategory;
  final int? selectedIndex;
  final double transitionProgress;

  // if set : draw a full circle behind the sbucategory chart
  final Color? backgroundColor;

  final ValueChanged<int> onSelection;

  final ValueNotifier<TooltipNotification?> tooltipData = ValueNotifier(null);

  ChartView({
    super.key,
    required this.anim,
    required this.intervals,
    required this.segments,
    required this.transitionProgress,
    required this.onSelection,
    this.categories,
    this.selectedCategory,
    this.selectedIndex,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) =>
      NotificationListener<TooltipNotification>(
        onNotification: (notification) {
          tooltipData.value = notification.hide ? null : notification;
          return false;
        },
        child: AnimatedBuilder(
          animation: anim,
          builder: (context, _) => FittedBox(
            fit: BoxFit.fill,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                ...enumerate(segments).map(
                  (e) {
                    return Center(
                      child: Opacity(
                        opacity: e.index == selectedIndex
                            ? 0
                            : 1 - transitionProgress,
                        child: DonutSegmentPaint(
                          key: const Key('donut'),
                          e.value,
                          progress: intervals[e.index].value,
                          transitionProgress: e.index == selectedIndex ? 1 : 0,
                          onSelection: categories == null
                              ? null
                              : () => onSelection(e.index),
                        ),
                      ),
                    );
                  },
                ).toList(),
                // si une category est sélectionnée
                // on n'affiche que le segment sélectionné
                if (selectedIndex != null)
                  Center(
                    child: DonutSegmentPaint(
                      key: const Key('donut-solo'),
                      segments.length > selectedIndex!
                          ? segments[selectedIndex!]
                          : segments.first,
                      transitionProgress: transitionProgress,
                      progress: intervals.length > selectedIndex!
                          ? intervals[selectedIndex!].value
                          : intervals.first.value,
                      onSelection: () {},
                    ),
                  ),
                ValueListenableBuilder<TooltipNotification?>(
                  valueListenable: tooltipData,
                  builder: (context, value, _) =>
                      value != null && value.title!.isNotEmpty
                          ? Positioned(
                              left: value.position!.dx - 40,
                              top: value.position!.dy,
                              child: IgnorePointer(
                                ignoring: true,
                                child: SegmentTooltip(
                                  title: value.title!,
                                  subtitle: value.subtitle!,
                                  color: value.color!,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                )
              ],
            ),
          ),
        ),
      );
}

class SegmentTooltip extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const SegmentTooltip({
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.milliseconds,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HSLColor.fromColor(color)
                  .withLightness(.45)
                  .withSaturation(.3)
                  .toColor(),
              HSLColor.fromColor(color)
                  .withLightness(.3)
                  .withSaturation(.3)
                  .toColor(),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.all(8),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: '$title\n',
            style: const TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: subtitle,
            style: const TextStyle(color: Colors.amber),
          ),
        ]),
      ),
    );
  }
}
