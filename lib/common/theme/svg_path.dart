import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

extension SvgsExtension on ColorFilter {
  static ColorFilter colorFilter(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }
}

class Svgs {
  static const shopSolid =
      AssetBytesLoader("assets/images/collab/shop-solid.svg.vec");
  static const spinnerSolid =
      AssetBytesLoader("assets/images/common/spinner-solid.svg.vec");
  static const torii = AssetBytesLoader("assets/images/common/torii.svg.vec");
  static const boltSoild =
      AssetBytesLoader("assets/images/home/bolt-solid.svg.vec");
  static const heartRegular =
      AssetBytesLoader("assets/images/home/heart-regular.svg.vec");
  static const heartSoild =
      AssetBytesLoader("assets/images/home/heart-solid.svg.vec");
  static const shirtSolid =
      AssetBytesLoader("assets/images/home/shirt-solid.svg.vec");
  static const stamp = AssetBytesLoader("assets/images/quest/stamp.svg.vec");
  static const pSoild =
      AssetBytesLoader("assets/images/scanPay/p-solid.svg.vec");
}
