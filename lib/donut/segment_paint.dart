import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'notification.dart';
import 'segment_data.dart';

const graphSize = Size(300, 300);

class DonutSegment extends StatelessWidget {
  final ArcData data;
  final double progress;

  /// progression durant hero transition
  final double? transitionProgress;
  final VoidCallback? onSelection;

  const DonutSegment({
    required this.data,
    required this.progress,
    this.transitionProgress,
    this.onSelection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HoverableWidget<ArcData>(
      data,
      notificationBuilder: ShowTooltip.new,
      onSelection: onSelection,
      child: SegmentPaint(
        data: data,
        progress: progress,
        transitionProgress: transitionProgress,
      ),
    );
  }
}

class HoverableWidget<T> extends StatelessWidget {
  final Widget child;

  final T data;

  final VoidCallback? onSelection;

  final DonutNotification Function(T, Offset) notificationBuilder;

  const HoverableWidget(
    this.data, {
    required this.child,
    required this.notificationBuilder,
    this.onSelection,
    super.key,
  });

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: MaterialStateMouseCursor.clickable,
        onEnter: (event) => _notify(
          context: context,
          data: data,
          position: event.localPosition,
        ),
        onHover: (event) => _notify(
          context: context,
          data: data,
          position: event.localPosition,
        ),
        onExit: (event) => HideTooltip().dispatch(context),
        opaque: false,
        hitTestBehavior: HitTestBehavior.deferToChild,
        child: GestureDetector(
          onTap: onSelection,
          child: child,
        ),
      );

  void _notify({
    required BuildContext context,
    required T data,
    required Offset position,
  }) =>
      notificationBuilder(data, position).dispatch(context);
}

class SegmentPaint extends StatelessWidget {
  const SegmentPaint({
    Key? key,
    required this.data,
    required this.progress,
    required this.transitionProgress,
  }) : super(key: key);

  final ArcData data;
  final double progress;
  final double? transitionProgress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: graphSize,
      painter: DonutSegmentPainter(
        data,
        progress: progress,
        transitionProgress: transitionProgress,
        size: graphSize,
      ),
    );
  }
}

class DonutSegmentPainter extends CustomPainter {
  final ArcData data;
  final double progress;
  final double? transitionProgress;
  final Size size;

  Path get path {
    final center = size.center(Offset.zero);
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx, 0);
    path.addArc(
      Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
      data.startAngle,
      transitionProgress == null || transitionProgress == 0
          ? data.sweepAngle * progress
          : data.sweepAngle * progress +
              (2 * pi - data.sweepAngle) * transitionProgress!,
    );
    path.lineTo(center.dx, center.dy);
    return path..close();
  }

  DonutSegmentPainter(
    this.data, {
    required this.progress,
    required this.size,
    this.transitionProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    // clip center circle
    canvas.clipPath(
      Path()
        ..addOval(
          Rect.fromCenter(
            center: center,
            width: size.width / 2,
            height: size.height / 2,
          ),
        )
        ..addRect(
          Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
        )
        ..fillType = PathFillType.evenOdd,
    );

    canvas.drawPath(path, Paint()..color = data.color);

    // softlight shadow
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(DonutSegmentPainter oldDelegate) => true;

  @override
  bool? hitTest(Offset position) => path.contains(position);
}

final shadowPaint = Paint()
  ..blendMode = BlendMode.softLight
  ..shader = ui.Gradient.radial(
    graphSize.center(Offset.zero),
    graphSize.width / 2,
    [Colors.black38, Colors.transparent, Colors.transparent, Colors.black26],
    [0.45, .6, .9, 1],
  );
