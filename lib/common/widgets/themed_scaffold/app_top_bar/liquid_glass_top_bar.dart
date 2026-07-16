import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/widgets/themed_bottom_sheet/themed_bottom_sheet.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/change_background_bottom_sheet/liquid_glass_change_background_bottom_sheet.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/gen/assets.gen.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/route/app_route.dart';

class LiquidGlassTopBar extends StatelessWidget {
  const LiquidGlassTopBar({super.key});

  static const height = 38.0;

  @override
  Widget build(BuildContext context) {
    void onLangChanged(Locale locale) {
      context.read<LanguageProvider>().setUserPrefLocale(locale);
    }

    void onShowChangeVisualBottomSheet() {
      showThemedModalBottomSheet(
        context: context,
        title: '更換角色/衣裝',
        builder: (context) => const LiquidGlassChangeBackgroundBottomSheet(),
      );
    }

    void onOpenSettingsPagePressed() {
      context.goNamed(AppRoute.settings.routeName);
    }

    return GlassAppBar(
      leading: CircleAvatar(
        backgroundImage: R.images.home.a50paylogoMin.provider(),
      ),
      actions: [
        GlassButton(
          width: height,
          height: height,
          icon: const Icon(Icons.brush_rounded),
          onTap: onShowChangeVisualBottomSheet,
        ),
        Selector<LanguageProvider, Locale>(
          selector: (context, provider) => provider.currentLocale,
          builder: (context, locale, child) {
            return GlassPullDownButton(
              icon: const Icon(Icons.language_rounded),
              label: locale.displayText,
              buttonHeight: height,
              buttonWidth: 127.5,
              buttonShape: const LiquidRoundedRectangle(borderRadius: 100),
              items: S.delegate.supportedLocales.map((e) {
                final title = e.displayText;
                final isSelected = e == locale;
                final trailingCheckmark = isSelected
                    ? Icon(
                        CupertinoIcons.checkmark_alt,
                        size: 16,
                        color: CupertinoColors.label.resolveFrom(context),
                      )
                    : null;
                return GlassMenuItem(
                  isSelected: isSelected,
                  title: title,
                  trailing: trailingCheckmark,
                  onTap: () {
                    onLangChanged(e);
                  },
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(width: 2),
        GlassButton(
          icon: const Icon(Icons.settings),
          width: height,
          height: height,
          onTap: onOpenSettingsPagePressed,
        ),
      ],
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
      preferredSize: const Size.fromHeight(height),
    );
  }
}
