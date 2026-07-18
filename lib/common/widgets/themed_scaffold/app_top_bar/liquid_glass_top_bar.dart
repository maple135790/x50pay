import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/widgets/themed_bottom_sheet/themed_bottom_sheet.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/change_background_bottom_sheet/liquid_glass_change_background_bottom_sheet.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/top_bar_widget_builder.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/gen/assets.gen.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/route/app_route.dart';

class LiquidGlassTopBar extends StatelessWidget {
  final TopBarWidgetBuilder builder;
  const LiquidGlassTopBar(this.builder, {super.key});

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

    void onPointInfoPressed() {
      // TODO: implement onPointInfoPressed
    }

    final languageButton = Selector<LanguageProvider, Locale>(
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
    );

    final pointButton = GlassButton.custom(
      shape: const LiquidRoundedRectangle(borderRadius: 50),
      onTap: onPointInfoPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: builder.pointInfo(context),
      ),
    );

    final changeVisualButton = GlassButton(
      width: height,
      height: height,
      icon: const Icon(Icons.brush_rounded),
      onTap: onShowChangeVisualBottomSheet,
    );

    final appIcon = CircleAvatar(
      backgroundImage: R.images.home.a50paylogoMin.provider(),
    );

    final backButton = GlassIconButton(
      shape: .circle,
      icon: const Icon(Icons.chevron_left_rounded, size: 28),
      onPressed: () {
        context.pop();
      },
    );

    return GlassAppBar(
      leading: ValueListenableBuilder(
        valueListenable: GoRouter.of(context).routeInformationProvider,
        builder: (context, infoProvider, child) {
          final isAtHome = infoProvider.uri.path == AppRoute.home.path;
          if (!isAtHome) return backButton;
          return appIcon;
        },
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: GoRouter.of(context).routeInformationProvider,
          builder: (context, infoProvider, child) {
            final isAtHome = infoProvider.uri.path == AppRoute.home.path;
            return isAtHome ? changeVisualButton : const SizedBox();
          },
        ),
        ValueListenableBuilder(
          valueListenable: GoRouter.of(context).routeInformationProvider,
          builder: (context, infoProvider, child) {
            final isAtHome = infoProvider.uri.path == AppRoute.home.path;
            return isAtHome ? languageButton : pointButton;
          },
        ),
        // const SizedBox(width: 2),
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
