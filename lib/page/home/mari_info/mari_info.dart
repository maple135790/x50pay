import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/mari_info/liquid_glass_mari_info.dart';
import 'package:x50pay/page/home/mari_info/material_mari_info.dart';
import 'package:x50pay/page/home/progress_bar.dart';

class MariInfo extends StatelessWidget {
  /// 真璃養成點數資訊
  ///
  /// 包含等級、養成點數、養成點數進度條、養成點數商城按鈕等
  const MariInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final widgetBuilder = MariWidgetBuilder();
    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => LiquidGlassMariInfo(widgetBuilder),
      materialWidgetBuilder: () => MaterialMariInfo(widgetBuilder),
    );
  }
}

class MariWidgetBuilder {
  static const _mariHeight = 270.0;

  late final _logger = Logger('MariWidgetBuilder');

  Widget _handleMariImageError(
    BuildContext context,
    Object error,
    StackTrace? st,
  ) {
    _logger.warning("", error, st);
    return const Tooltip(
      message: "資料錯誤",
      child: SizedBox(
        height: _mariHeight,
        child: Icon(Icons.warning_amber_rounded),
      ),
    );
  }

  Widget _buildInfo(
    String current, {
    required String next,
    required double fontSize,
  }) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: fontSize),
        children: [
          TextSpan(
            text: current,
            style: const TextStyle(color: Color(0xfffafafa)),
          ),
          TextSpan(
            text: "/$next",
            style: const TextStyle(color: Color(0xffb4b4b4)),
          ),
        ],
      ),
    );
  }

  Widget _progressBarInfo({
    required Widget icon,
    required Widget title,
    required Widget trailing,
    required double value,
    Color progressColor = const Color(0xffff9bad),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 1.5,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 5),
            title,
            const SizedBox(width: 5),
            const Spacer(),
            trailing,
          ],
        ),
        ProgressBar(
          height: 5.25,
          progressText: "",
          currentValue: value,
          progressColor: progressColor,
        ),
      ],
    );
  }

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 5),
          Expanded(
            child: Wrap(
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 11.2)),
                Text(
                  value,
                  softWrap: false,
                  style: const TextStyle(fontSize: 11.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gradeProgressbar(EntryModel entry) {
    final gradeIcon = SvgPicture(
      Svgs.heartSoild,
      width: 14.8,
      height: 14.8,
      colorFilter: SvgsExtension.colorFilter(const Color(0xbfff1100)),
    );

    final gradeInfo = _buildInfo(
      entry.gradeLv,
      next: entry.gr2Next,
      fontSize: 14.8,
    );

    final boltIcon = SvgPicture(
      Svgs.boltSoild,
      width: 11,
      height: 13,
      colorFilter: SvgsExtension.colorFilter(const Color(0xfffadb14)),
    );

    return _progressBarInfo(
      icon: gradeIcon,
      title: gradeInfo,
      trailing: boltIcon,
      value: entry.gr2Progress,
    );
  }

  Widget pointProgressBar(EntryModel entry) {
    final gameIcon = const Icon(Icons.videogame_asset_rounded, size: 13);

    final countInfo = _buildInfo(
      entry.gr2CountMuch,
      next: "${entry.gr2HowMuch} P",
      fontSize: 11.34,
    );

    final pointIcon = const Text(
      "P",
      style: TextStyle(
        color: Color(0xfffadb14),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
    return _progressBarInfo(
      icon: gameIcon,
      title: countInfo,
      trailing: pointIcon,
      value: entry.gr2Progress,
      progressColor: const Color(0xffffde9b),
    );
  }

  Widget fpProgressBar(EntryModel entry) {
    final fpIcon = const Icon(Icons.card_giftcard_rounded, size: 13);

    final flagIcon = const Icon(
      Icons.flag_rounded,
      size: 11,
      color: Color(0xfffadb14),
    );

    final fpInfo = _buildInfo(
      entry.gr2MuchFP,
      next: entry.gr2LimitFP,
      fontSize: 8.82,
    );

    return _progressBarInfo(
      icon: fpIcon,
      title: fpInfo,
      trailing: flagIcon,
      value: entry.gr2Progress,
      progressColor: const Color(0xffffde9b),
    );
  }

  Widget levelText(
    EntryModel entry, {
    required S i18n,
    required Widget gradeBoxShopButton,
  }) {
    final bounsInfo = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 11.2),
          children: [
            const WidgetSpan(child: Icon(Icons.redeem_rounded, size: 15)),
            const WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: i18n.gr2Limit(entry.gr2Limit)),
          ],
        ),
      ),
    );

    final loginDayTitle = i18n.continuous(entry.gr2Day).split(" : ").first;
    final loginDayValue = i18n.continuous(entry.gr2Day).split(" : ").last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bounsInfo,
        infoItem(
          icon: Icons.calendar_today_rounded,
          title: "$loginDayTitle : ",
          value: loginDayValue,
        ),
        infoItem(
          icon: Icons.sync_rounded,
          title: i18n.gr2ResetDate,
          value: entry.gr2Date,
        ),
        const SizedBox(height: 10),
        Center(child: gradeBoxShopButton),
      ],
    );
  }

  Widget gradeBoxShopButtonText({required S i18n}) {
    return Text(
      i18n.gr2HeartBox,
      style: const TextStyle(
        color: Color(0xfff5222d),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget cmDoneMask(EntryModel entry) {
    if (entry.grCMDone) return const SizedBox();
    return const ColoredBox(
      color: Colors.black45,
      child: Center(child: Text('已達成獎勵')),
    );
  }

  Widget mariImage(EntryModel entry) {
    return FadeInImage(
      image: MemoryImage(entry.ava),
      placeholder: MemoryImage(kTransparentImage),
      imageErrorBuilder: _handleMariImageError,
      fadeInDuration: const Duration(milliseconds: 150),
      fit: BoxFit.contain,
      alignment: Alignment.center,
      height: _mariHeight,
    );
  }
}
