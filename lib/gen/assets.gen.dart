/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/appIcon
  $AssetsImagesAppIconGen get appIcon => const $AssetsImagesAppIconGen();

  /// Directory path: assets/images/collab
  $AssetsImagesCollabGen get collab => const $AssetsImagesCollabGen();

  /// Directory path: assets/images/common
  $AssetsImagesCommonGen get common => const $AssetsImagesCommonGen();

  /// Directory path: assets/images/game
  $AssetsImagesGameGen get game => const $AssetsImagesGameGen();

  /// Directory path: assets/images/home
  $AssetsImagesHomeGen get home => const $AssetsImagesHomeGen();

  /// Directory path: assets/images/quest
  $AssetsImagesQuestGen get quest => const $AssetsImagesQuestGen();

  /// Directory path: assets/images/scanPay
  $AssetsImagesScanPayGen get scanPay => const $AssetsImagesScanPayGen();
}

class $AssetsTextsGen {
  const $AssetsTextsGen();

  /// File path: assets/texts/license.txt
  String get license => 'assets/texts/license.txt';

  /// List of all assets
  List<String> get values => [license];
}

class $AssetsImagesAppIconGen {
  const $AssetsImagesAppIconGen();

  /// File path: assets/images/appIcon/appstore.png
  AssetGenImage get appstore =>
      const AssetGenImage('assets/images/appIcon/appstore.png');

  /// File path: assets/images/appIcon/playstore.png
  AssetGenImage get playstore =>
      const AssetGenImage('assets/images/appIcon/playstore.png');

  /// List of all assets
  List<AssetGenImage> get values => [appstore, playstore];
}

class $AssetsImagesCollabGen {
  const $AssetsImagesCollabGen();

  /// File path: assets/images/collab/shop-solid.svg.vec
  String get shopSolidSvg => 'assets/images/collab/shop-solid.svg.vec';

  /// List of all assets
  List<String> get values => [shopSolidSvg];
}

class $AssetsImagesCommonGen {
  const $AssetsImagesCommonGen();

  /// File path: assets/images/common/header_icon_rsz.png
  AssetGenImage get headerIconRsz =>
      const AssetGenImage('assets/images/common/header_icon_rsz.png');

  /// File path: assets/images/common/logo_150.jpg
  AssetGenImage get logo150 =>
      const AssetGenImage('assets/images/common/logo_150.jpg');

  /// File path: assets/images/common/spinner-solid.svg.vec
  String get spinnerSolidSvg => 'assets/images/common/spinner-solid.svg.vec';

  /// File path: assets/images/common/torii.svg.vec
  String get toriiSvg => 'assets/images/common/torii.svg.vec';

  /// List of all assets
  List<dynamic> get values =>
      [headerIconRsz, logo150, spinnerSolidSvg, toriiSvg];
}

class $AssetsImagesGameGen {
  const $AssetsImagesGameGen();

  /// File path: assets/images/game/heart-circle-plus-solid.svg.vec
  String get heartCirclePlusSolidSvg =>
      'assets/images/game/heart-circle-plus-solid.svg.vec';

  /// List of all assets
  List<String> get values => [heartCirclePlusSolidSvg];
}

class $AssetsImagesHomeGen {
  const $AssetsImagesHomeGen();

  /// File path: assets/images/home/bolt-solid.svg.vec
  String get boltSolidSvg => 'assets/images/home/bolt-solid.svg.vec';

  /// File path: assets/images/home/heart-regular.svg
  String get heartRegular => 'assets/images/home/heart-regular.svg';

  /// File path: assets/images/home/heart-regular.svg.vec
  String get heartRegularSvg => 'assets/images/home/heart-regular.svg.vec';

  /// File path: assets/images/home/heart-solid.svg.vec
  String get heartSolidSvg => 'assets/images/home/heart-solid.svg.vec';

  /// Directory path: assets/images/home/mari_level
  $AssetsImagesHomeMariLevelGen get mariLevel =>
      const $AssetsImagesHomeMariLevelGen();

  /// File path: assets/images/home/shirt-solid.svg.vec
  String get shirtSolidSvg => 'assets/images/home/shirt-solid.svg.vec';

  /// File path: assets/images/home/top.png
  AssetGenImage get top => const AssetGenImage('assets/images/home/top.png');

  /// File path: assets/images/home/vts.png
  AssetGenImage get vts => const AssetGenImage('assets/images/home/vts.png');

  /// List of all assets
  List<dynamic> get values => [
        boltSolidSvg,
        heartRegular,
        heartRegularSvg,
        heartSolidSvg,
        shirtSolidSvg,
        top,
        vts
      ];
}

class $AssetsImagesQuestGen {
  const $AssetsImagesQuestGen();

  /// File path: assets/images/quest/stamp.svg.vec
  String get stampSvg => 'assets/images/quest/stamp.svg.vec';

  /// List of all assets
  List<String> get values => [stampSvg];
}

class $AssetsImagesScanPayGen {
  const $AssetsImagesScanPayGen();

  /// File path: assets/images/scanPay/jkopay_logo.png
  AssetGenImage get jkopayLogo =>
      const AssetGenImage('assets/images/scanPay/jkopay_logo.png');

  /// File path: assets/images/scanPay/linepay_logo.png
  AssetGenImage get linepayLogo =>
      const AssetGenImage('assets/images/scanPay/linepay_logo.png');

  /// File path: assets/images/scanPay/p-solid.svg.vec
  String get pSolidSvg => 'assets/images/scanPay/p-solid.svg.vec';

  /// List of all assets
  List<dynamic> get values => [jkopayLogo, linepayLogo, pSolidSvg];
}

class $AssetsImagesHomeMariLevelGen {
  const $AssetsImagesHomeMariLevelGen();

  /// File path: assets/images/home/mari_level/ouo.png
  AssetGenImage get ouo =>
      const AssetGenImage('assets/images/home/mari_level/ouo.png');

  /// List of all assets
  List<AssetGenImage> get values => [ouo];
}

class R {
  R._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTextsGen texts = $AssetsTextsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size = null});

  final String _assetName;

  final Size? size;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
