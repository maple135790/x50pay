import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';
import 'package:x50pay/page/home/ticket_info/liquid_glass_ticket_info.dart';
import 'package:x50pay/page/home/ticket_info/material_ticket_info.dart';

class TicketInfo extends StatelessWidget {
  final List<StampData>? data;

  /// 票券資訊
  ///
  /// 包含券量、月票、月票期限
  const TicketInfo(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final builder = StampWidgetBuilder(data);

    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => LiquidGlassTicketInfo(builder),
      materialWidgetBuilder: () => MaterialTicketInfo(builder),
    );
  }
}

class StampWidgetBuilder {
  final List<StampData>? data;

  const StampWidgetBuilder(this.data);

  Widget? stamp(int index) {
    if (data == null) return null;
    final stamp = data?.elementAtOrNull(index);
    if (stamp == null) return null;
    final uri = stamp.fileUri.replace(scheme: "https", host: "pay.x50.fun");
    return Image.network(uri.toString(), width: 43, height: 43);
  }
}
