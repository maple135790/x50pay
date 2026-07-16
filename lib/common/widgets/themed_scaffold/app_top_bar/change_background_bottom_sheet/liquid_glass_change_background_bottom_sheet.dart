import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/models/grade_background/grade_background.dart';
import 'package:x50pay/providers/home_background_provider.dart';
import 'package:x50pay/providers/home_refresh_provider.dart';

class LiquidGlassChangeBackgroundBottomSheet extends StatefulWidget {
  const LiquidGlassChangeBackgroundBottomSheet({super.key});

  @override
  State<LiquidGlassChangeBackgroundBottomSheet> createState() =>
      _LiquidGlassChangeBackgroundBottomSheetState();
}

class _LiquidGlassChangeBackgroundBottomSheetState
    extends State<LiquidGlassChangeBackgroundBottomSheet>
    with AppFeedbackMixin {
  late final Future<List> getBackgoundList;

  @override
  void initState() {
    super.initState();
    getBackgoundList = [
      context.read<HomeBackgroundProvider>().getBackgoundList(),
      Future.delayed(Durations.long2),
    ].wait;
  }

  void onBackgroundItemPressed(GradeBackground data) async {
    final refresher = context.read<HomeRefreshProvider?>();
    final nav = Navigator.of(context);
    final isSuccess = await context
        .read<HomeBackgroundProvider>()
        .changeBackground(data);
    if (!isSuccess) return;
    showSuccess("更換成功!");
    await Future.delayed(Durations.extralong4);
    nav.pop();
    refresher?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xff1e1e1e),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder(
        future: getBackgoundList,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final backgroundData = snapshot.data!.first;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 168 / 190,
            ),
            itemCount: backgroundData.length,
            itemBuilder: (context, index) {
              final data = backgroundData[index];
              return buildBackgroundItem(data);
            },
          );
        },
      ),
    );
  }

  Widget buildBackgroundItem(GradeBackground data) {
    final title = data.name.replaceFirst("[", "\n[");

    return GestureDetector(
      onTap: () {
        onBackgroundItemPressed(data);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xffd3d3d3),
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: .topRight,
            image: CachedNetworkImageProvider(
              BackgroundPath.fromModel(data).fullUrl.toString(),
              maxWidth: 500,
              maxHeight: 500,
            ),
          ),
        ),
        alignment: .bottomCenter,
        child: GlassContainer(
          width: double.maxFinite,
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 11),
          settings: const LiquidGlassSettings(glassColor: Colors.white12),
          shape: const LiquidRoundedRectangle(borderRadius: 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: .w600,
                height: 1.2,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 8)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
