import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';
import 'package:x50pay/page/home/event_info/liquid_glass_event_info.dart';
import 'package:x50pay/page/home/event_info/material_event_info.dart';

class EventInfo extends StatelessWidget {
  /// 活動資訊
  final List<Evlist> events;

  /// 訊息告知區塊
  const EventInfo({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final messages = events.map((e) => "${e.name} : ${e.describe}");

    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => LiquidGlassEventInfo(messages),
      materialWidgetBuilder: () => MaterialEventInfo(messages),
    );
  }
}
