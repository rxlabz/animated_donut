import 'package:flutter/widgets.dart';

import 'segment_data.dart';

class DonutNotification extends Notification {}

class HideTooltip extends DonutNotification {}

class ShowTooltip extends DonutNotification {
  final Offset position;
  final String title;
  final String subtitle;
  final Color color;

  ShowTooltip(ArcData data, this.position)
      : title = data.title,
        subtitle = data.subtitle,
        color = data.color;

  bool get isEmpty => title.isEmpty;
}
