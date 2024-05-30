import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/gen/assets.gen.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/language_provider.dart';

class PersistentAppBar extends StatefulWidget {
  const PersistentAppBar({super.key});

  @override
  State<PersistentAppBar> createState() => _PersistentAppBarState();
}

class _PersistentAppBarState extends BaseStatefulState<PersistentAppBar> {
  void onLanguagePressed(Locale currentLocale) async {
    final changedLocale = await showDialog<Locale>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(S.of(context).x50PayLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              S.delegate.supportedLocales.length,
              (index) => RadioListTile<Locale>(
                visualDensity: VisualDensity.compact,
                controlAffinity: ListTileControlAffinity.trailing,
                value: S.delegate.supportedLocales[index],
                title: Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      S.delegate.supportedLocales[index].countryCode ?? '',
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(S.delegate.supportedLocales[index].displayText),
                  ],
                ),
                groupValue: currentLocale,
                onChanged: (value) {
                  context.pop(value);
                },
              ),
              growable: false,
            ),
          ),
        );
      }),
    );
    if (changedLocale == null) return;
    if (!mounted) return;
    EasyLoading.show();
    Future.delayed(const Duration(milliseconds: 800), () {
      EasyLoading.dismiss();
      context.read<LanguageProvider>().setUserPrefLocale(changedLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                color: isDarkTheme
                    ? CustomColorThemes.borderColorDark
                    : CustomColorThemes.borderColorLight,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: CircleAvatar(
                    backgroundImage: R.images.common.headerIconRsz.provider(),
                    backgroundColor: Colors.black,
                    radius: 14,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Consumer<LanguageProvider>(
                    builder: (context, vm, child) => Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          onLanguagePressed(vm.currentLocale);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 6.75,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? CustomColorThemes.appbarBoxColorDark
                                  : CustomColorThemes.appbarBoxColorLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CountryFlag.fromCountryCode(
                                  vm.currentLocale.countryCode ?? '',
                                  height: 15,
                                  width: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  vm.currentLocale.displayText,
                                  textScaler: const TextScaler.linear(0.85),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
