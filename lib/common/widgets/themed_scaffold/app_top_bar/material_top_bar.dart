import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/change_background_bottom_sheet/change_background_bottom_sheet.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/gen/assets.gen.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/route/app_route.dart';

class MaterialTopBar extends StatefulWidget implements PreferredSizeWidget {
  const MaterialTopBar({super.key});

  @override
  State<MaterialTopBar> createState() => _MaterialTopBarState();
  @override
  Size get preferredSize => const Size.fromHeight(51);
}

class _MaterialTopBarState extends State<MaterialTopBar> {
  AnimationStatus _status = AnimationStatus.dismissed;
  @override
  Widget build(BuildContext context) {
    void onLangChanged(Locale locale) {
      context.read<LanguageProvider>().setUserPrefLocale(locale);
    }

    void onShowChangeVisualBottomSheet() {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: false,
        useSafeArea: true,
        scrollControlDisabledMaxHeightRatio: 0.85,
        builder: (context) {
          return const ChangeBackgroundBottomSheet();
        },
      );
    }

    void onOpenSettingsPagePressed() {
      context.goNamed(AppRoute.settings.routeName);
    }

    final languageButton = Selector<LanguageProvider, Locale>(
      selector: (context, provider) => provider.currentLocale,
      builder: (context, locale, child) {
        return CupertinoMenuAnchor(
          constrainCrossAxis: true,
          constraints: const BoxConstraints(maxWidth: 155),
          onAnimationStatusChanged: (status) {
            setState(() {
              _status = status;
            });
          },
          menuChildren: S.delegate.supportedLocales.map((e) {
            final title = e.displayText;
            final trailingCheckmark = e == locale
                ? Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 16,
                    color: CupertinoColors.label.resolveFrom(context),
                  )
                : null;
            return CupertinoMenuItem(
              trailing: trailingCheckmark,
              onPressed: () {
                onLangChanged(e);
              },
              child: Text(title),
            );
          }).toList(),
          builder: (context, controller, child) {
            return GestureDetector(
              onTap: () {
                if (_status.isForwardOrCompleted) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: child,
            );
          },
          child: MaterialGlass.withShadow(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            borderRadius: 50,
            color: Colors.white30,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Text(
                  locale.displayTextShort,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 12, color: Colors.black54)],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 12, color: Colors.black54)],
                ),
              ],
            ),
          ),
        );
      },
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        child: Row(
          children: [
            PhysicalModel(
              color: Colors.transparent,
              shape: BoxShape.circle,
              clipBehavior: Clip.hardEdge,
              elevation: 1.2,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: R.images.home.a50paylogoMin.provider(),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onShowChangeVisualBottomSheet,
              child: const MaterialGlass.withShadow(
                width: 32,
                height: 32,
                shape: .circle,
                color: Colors.white24,
                child: Icon(
                  Icons.brush_rounded,
                  size: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 12, color: Colors.black54)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            MaterialGlass.withShadow(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 6),
              color: Colors.white24,
              borderRadius: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  languageButton,
                  const SizedBox(width: 10),
                  SizedBox.square(
                    dimension: 28,
                    child: InkWell(
                      onTap: onOpenSettingsPagePressed,
                      child: const Icon(
                        Icons.settings_rounded,
                        size: 24,
                        shadows: [
                          Shadow(blurRadius: 12, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
