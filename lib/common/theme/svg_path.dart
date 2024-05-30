import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';
import 'package:x50pay/gen/assets.gen.dart';

extension SvgsExtension on ColorFilter {
  static ColorFilter colorFilter(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }
}

class Svgs {
  static final shopSolid = AssetBytesLoader(R.images.collab.shopSolidSvg);
  static final spinnerSolid = AssetBytesLoader(R.images.common.spinnerSolidSvg);
  static final torii = AssetBytesLoader(R.images.common.toriiSvg);
  static final boltSoild = AssetBytesLoader(R.images.home.boltSolidSvg);
  static final heartSoild = AssetBytesLoader(R.images.home.heartSolidSvg);
  static final shirtSolid = AssetBytesLoader(R.images.home.shirtSolidSvg);
  static final stamp = AssetBytesLoader(R.images.quest.stampSvg);
  static final pSoild = AssetBytesLoader(R.images.scanPay.pSolidSvg);
  static final heartCirclePlus =
      AssetBytesLoader(R.images.game.heartCirclePlusSolidSvg);
}
