import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/generated/l10n.dart';

class ConfirmExitDialog extends StatelessWidget {
  const ConfirmExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = S.of(context);
    return AlertDialog(
      title: Text(i18n.confirmExitAppTitle),
      content: Text(i18n.confirmExitAppContent),
      actions: [
        TextButton(
          style: CustomButtonThemes.severe(isV4: true),
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Text(i18n.dialogConfirm),
        ),
        TextButton(
          style: CustomButtonThemes.cancel(
            isDarkMode: AppThemeHelper(context).isDarkTheme,
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(i18n.dialogCancel),
        ),
      ],
    );
  }
}
