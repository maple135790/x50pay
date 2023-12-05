/// Copyright (C), 2018-2019, York
/// FileName: asset_svg.dart
/// Author: York
/// Date: 2019-11-01 11:39
/// Description: AssetSvg is a svgImageProvider for imageWidget
/// License: The AssetSvg was copied and modified from [flutter_svg_provider](https://github.com/yang-f/flutter_svg_provider), Apache License 2.0 Copyright (C) 2018-2019 yang-f

library r_dart_library;

import 'dart:async';
import 'dart:ui' as ui show PictureRecorder, Canvas, Picture;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetSvg extends ImageProvider<AssetSvg> {
  final String asset;
  final double width;
  final double height;

  const AssetSvg(this.asset, {this.width = 100, this.height = 100});

  @override
  Future<AssetSvg> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetSvg>(this);
  }

  @override
  ImageStreamCompleter loadImage(AssetSvg key, nil) {
    return OneFrameImageStreamCompleter(
      _loadAsync(key),
    );
  }

  Future<ImageInfo> _loadAsync(AssetSvg key) async {
    assert(key == this);
    var rawSvg = await rootBundle.loadString(key.asset);
    final pictureInfo = await vg.loadPicture(
      SvgStringLoader(rawSvg),
      null,
      clipViewbox: false,
    );

    final ui.PictureRecorder recorder = ui.PictureRecorder();

    ui.Canvas(recorder)
      ..scale(key.width / pictureInfo.size.width,
          key.height / pictureInfo.size.height)
      ..drawPicture(pictureInfo.picture);

    final ui.Picture scaledPicture = recorder.endRecording();

    final image =
        await scaledPicture.toImage(key.width.toInt(), key.height.toInt());

    return ImageInfo(
      image: image,
      scale: 1.0,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final AssetSvg typedOther = other;
    return asset == typedOther.asset &&
        width == typedOther.width &&
        height == typedOther.height;
  }

  @override
  int get hashCode => Object.hash(asset.hashCode, width, height, 1.0);

  @override
  String toString() => '$runtimeType(${describeIdentity(asset)}, scale: 1.0)';
}
