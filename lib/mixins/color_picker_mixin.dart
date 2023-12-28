import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:x50pay/common/base/base.dart';

mixin ColorPickerMixin<T extends StatefulWidget> on BaseStatefulState<T> {
  Color pickerColor();

  void onColorChanged(Color color);

  Future<void> showColorPicker() {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            content: SingleChildScrollView(
              child: ColorPicker(
                enableAlpha: false,
                pickerColor: pickerColor(),
                onColorChanged: onColorChanged,
              ),
            ),
          );
        });
  }
}
