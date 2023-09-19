import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';

class PageDialog extends StatefulWidget {
  final Widget Function(void Function(bool isShow) showButtonBar) content;
  final void Function()? onConfirm;
  final Widget? customConfirmButton;
  final String title;

  const PageDialog.ios({
    super.key,
    required this.content,
    required this.title,
    this.onConfirm,
    this.customConfirmButton,
  });

  @override
  State<PageDialog> createState() => _PageDialogState();
}

class _PageDialogState extends BaseStatefulState<PageDialog> {
  static const _kMaxBottomSheetHeight = 80.0;
  ValueNotifier<Offset> offsetNotifier =
      ValueNotifier(const Offset(0, _kMaxBottomSheetHeight));

  void showButtonBar(bool isShow) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (isShow) {
      offsetNotifier.value = Offset.zero;
    } else {
      offsetNotifier.value = const Offset(0, 1);
    }
  }

  final buttonStyle = ButtonStyle(
    shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
    backgroundColor: MaterialStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xfffafafa).withOpacity(0.5);
      return const Color(0xfffafafa);
    }),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.pageDialogBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 14, 28, 0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(child: widget.content.call(showButtonBar)),
        ],
      ),
      bottomSheet: ValueListenableBuilder(
        valueListenable: offsetNotifier,
        builder: (context, offset, child) {
          return AnimatedSlide(
            offset: offset,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 300),
            child: child,
          );
        },
        child: BottomSheet(
            onClosing: () {},
            dragHandleSize: Size.zero,
            backgroundColor: const Color(0xff2a2a2a),
            enableDrag: false,
            shape: const RoundedRectangleBorder(),
            builder: (context) => Container(
                  height: _kMaxBottomSheetHeight,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xff3e3e3e))),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: buttonStyle,
                            child: Text(i18n.dialogReturn,
                                style:
                                    const TextStyle(color: Color(0xff1e1e1e)))),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: widget.customConfirmButton == null
                            ? TextButton(
                                style: buttonStyle,
                                onPressed: widget.onConfirm,
                                child: Text(i18n.dialogSave,
                                    style: const TextStyle(
                                        color: Color(0xff1e1e1e))),
                              )
                            : widget.customConfirmButton!,
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}

class DialogSwitch extends StatefulWidget {
  final bool value;
  final String title;
  final void Function(bool value)? onChanged;

  const DialogSwitch.ios({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });

  @override
  State<DialogSwitch> createState() => _DialogSwitchState();
}

class _DialogSwitchState extends State<DialogSwitch> {
  bool v = false;

  @override
  void initState() {
    super.initState();
    v = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: Text(widget.title),
      trailing: CupertinoSwitch(
          activeColor: const Color(0xff005eb0),
          value: v,
          onChanged: (newValue) {
            v = newValue;
            setState(() {});
            widget.onChanged?.call(newValue);
          }),
    );
  }
}

class DialogDropdown<T> extends StatefulWidget {
  final String title;
  final T? value;
  final List<T> avaliList;
  final void Function(T value)? onChanged;

  const DialogDropdown.ios({
    super.key,
    required this.title,
    required this.value,
    required this.avaliList,
    required this.onChanged,
  });

  @override
  State<DialogDropdown<T>> createState() => _DialogDropdownState<T>();
}

class _DialogDropdownState<T> extends State<DialogDropdown<T>> {
  T? v;

  @override
  void initState() {
    super.initState();
    v = widget.value;
  }

  Widget buildCupertinoPicker() {
    return CupertinoPicker.builder(
      childCount: widget.avaliList.length,
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      scrollController: FixedExtentScrollController(
        initialItem: v == null ? 0 : widget.avaliList.indexOf(v as T),
      ),
      onSelectedItemChanged: (int selectedItem) {
        v = widget.avaliList[selectedItem];
        HapticFeedback.mediumImpact();
        setState(() {});
        widget.onChanged?.call(v as T);
      },
      itemBuilder: (context, index) => Center(
          child: Text(widget.avaliList[index].toString().split('.').last)),
    );
  }

  void _showCupertinoPickerDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: buildCupertinoPicker(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: Text(widget.title),
      onTap: _showCupertinoPickerDialog,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            v.toString().split('.').last,
            style: const TextStyle(
                color: CupertinoColors.systemGrey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          const CupertinoListTileChevron(),
        ],
      ),
    );
  }
}
