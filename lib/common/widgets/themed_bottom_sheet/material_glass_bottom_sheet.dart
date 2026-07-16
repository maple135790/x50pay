import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/widgets/material_glass.dart';

class MaterialGlassBottomSheet extends StatelessWidget {
  final String title;
  final WidgetBuilder builder;

  const MaterialGlassBottomSheet(
    this.title, {
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom,
        left: 8,
        right: 8,
      ),
      child: MaterialGlass(
        padding: const EdgeInsets.fromLTRB(26, 14, 26, 18),
        color: Colors.grey.shade800.withValues(alpha: .85),
        borderRadius: 16.5,
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: .w600),
                ),
                MaterialGlass.withShadow(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CloseButtonIcon(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: builder(context)),
          ],
        ),
      ),
    );
  }
}
