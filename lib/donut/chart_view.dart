import 'package:basics/int_basics.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../model.dart';
import 'notification.dart';
import 'segment_data.dart';
import 'segment_helpers.dart';
import 'segment_paint.dart';

const donutDuration = Duration(seconds: 1);

class ChartView extends StatelessWidget {
  final List<Animation> intervals;
  final List<ArcData> segments;
  final Animation<double> animation;

  final int? selectedIndex;
  final double transitionProgress;

  final ValueChanged<int> onSelection;

  final ValueNotifier<ShowTooltip?> tooltipData = ValueNotifier(null);

  ChartView({
    super.key,
    required this.animation,
    required List<AbstractCategory> categories,
    required this.transitionProgress,
    required this.onSelection,
    this.selectedIndex,
  })  : segments = computeArcs(categories),
        intervals = computeArcIntervals(
          anim: animation,
          categories: categories,
        );

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DonutNotification>(
      onNotification: (notification) {
        tooltipData.value = notification is ShowTooltip ? notification : null;
        return false;
      },
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) => FittedBox(
          fit: BoxFit.fill,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ...enumerate(segments).map(
                (segment) {
                  final opacity = segment.index == selectedIndex
                      ? 0.0
                      : 1 - transitionProgress;
                  return Opacity(
                    opacity: opacity,
                    child: DonutSegment(
                      key: const Key('donut'),
                      data: segment.value,
                      progress: intervals[segment.index].value,
                      transitionProgress:
                          segment.index == selectedIndex ? 1 : 0,
                      onSelection: () => onSelection(segment.index),
                    ),
                  );
                },
              ).toList(),
              // si une category est sélectionnée
              // on n'affiche que le segment sélectionné
              if (selectedIndex != null)
                DonutSegment(
                  key: const Key('donut-solo'),
                  data: segments.length > selectedIndex!
                      ? segments[selectedIndex!]
                      : segments.first,
                  transitionProgress: transitionProgress,
                  progress: intervals.length > selectedIndex!
                      ? intervals[selectedIndex!].value
                      : intervals.first.value,
                  onSelection: () {},
                ),
              ValueListenableBuilder<ShowTooltip?>(
                valueListenable: tooltipData,
                builder: (context, value, _) => value != null && !value.isEmpty
                    ? _SegmentTooltip(key: ValueKey(value), value)
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentTooltip extends StatelessWidget {
  final ShowTooltip _data;

  String get title => _data.title;

  String get subtitle => _data.subtitle;

  Color get color => _data.color;

  Offset get position => _data.position;

  const _SegmentTooltip(this._data, {super.key});

  @override
  Widget build(BuildContext context) => Positioned(
        left: position.dx - 40,
        top: position.dy - 52,
        child: IgnorePointer(
          ignoring: true,
          child: AnimatedContainer(
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
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 2, spreadRadius: 0.2, color: Colors.black45)
                ],
                borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.all(8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$title\n',
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: subtitle,
                    style: const TextStyle(color: Colors.amber),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
