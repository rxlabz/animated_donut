import 'dart:math';

import 'package:flutter/material.dart';

import 'model.dart';

class DonutSegmentPaint extends StatelessWidget {
  final SegmentData data;
  final double progress;

  /// progression durant hero transition
  final double? transitionProgress;

  final VoidCallback? onSelection;

  const DonutSegmentPaint(
    this.data, {
    required this.progress,
    this.onSelection,
    this.transitionProgress,
    super.key,
  });

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (event) => TooltipNotification(
          position: event.localPosition,
          title: data.title,
          subtitle: data.subtitle,
          color: data.color,
        ).dispatch(context),
        onHover: (event) => TooltipNotification(
          position: event.localPosition,
          title: data.title,
          subtitle: data.subtitle,
          color: data.color,
        ).dispatch(context),
        onExit: (event) => TooltipNotification.hide().dispatch(context),
        opaque: false,
        hitTestBehavior: HitTestBehavior.deferToChild,
        child: GestureDetector(
          onTap: onSelection,
          child: Stack(
            children: [
              CustomPaint(
                size: graphSize,
                painter: DonutSegmentPainter(
                  data,
                  progress: progress,
                  transitionProgress: transitionProgress,
                  size: graphSize,
                ),
              ),
            ],
          ),
        ),
      );
}

class DonutSegmentPainter extends CustomPainter {
  final SegmentData data;
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
  }

  @override
  bool shouldRepaint(DonutSegmentPainter oldDelegate) => true;

  @override
  bool? hitTest(Offset position) => path.contains(position);
}
