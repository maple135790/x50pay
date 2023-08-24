// IT IS GENERATED BY FLR - DO NOT MODIFY BY HAND
        // YOU CAN GET MORE DETAILS ABOUT FLR FROM:
        // - https://github.com/Fly-Mix/flr-cli
        // - https://github.com/Fly-Mix/flr-vscode-extension
        // - https://github.com/Fly-Mix/flr-as-plugin
        //

        // ignore_for_file: depend_on_referenced_packages

        // ignore: unused_import
        import 'package:flutter/widgets.dart';
        // ignore: unused_import
        import 'package:flutter/services.dart' show rootBundle;
        // ignore: unused_import
        import 'package:path/path.dart' as path;
        // ignore: unused_import
        import 'package:flutter_svg/flutter_svg.dart';
        // ignore: unused_import
        import 'package:r_dart_library/asset_svg.dart';
        
        /// This `R` class is generated and contains references to static asset resources.
        class R {
          /// package name: x50pay
          static const package = "x50pay";
        
          /// This `R.image` struct is generated, and contains static references to static non-svg type image asset resources.
          static const image = _R_Image();
        
          /// This `R.svg` struct is generated, and contains static references to static svg type image asset resources.
          static const svg = _R_Svg();
        
          /// This `R.text` struct is generated, and contains static references to static text asset resources.
          static const text = _R_Text();
        
          /// This `R.fontFamily` struct is generated, and contains static references to static font asset resources.
          static const fontFamily = _R_FontFamily();
        }
/// Asset resource’s metadata class.
      /// For example, here is the metadata of `packages/flutter_demo/assets/images/example.png` asset:
      /// - packageName：flutter_demo
      /// - assetName：assets/images/example.png
      /// - fileDirname：assets/images
      /// - fileBasename：example.png
      /// - fileBasenameNoExtension：example
      /// - fileExtname：.png
      class AssetResource {
        /// Creates an object to hold the asset resource’s metadata.
        const AssetResource(this.assetName, {this.packageName});
      
        /// The name of the main asset from the set of asset resources to choose from.
        final String assetName;
      
        /// The name of the package from which the asset resource is included.
        final String? packageName;
      
        /// The name used to generate the key to obtain the asset resource. For local assets
        /// this is [assetName], and for assets from packages the [assetName] is
        /// prefixed 'packages/<package_name>/'.
        String get keyName => packageName == null ? assetName : "packages/$packageName/$assetName";
      
        /// The file basename of the asset resource.
        String get fileBasename {
          final basename = path.basename(assetName);
          return basename;
        }
      
        /// The no extension file basename of the asset resource.
        String get fileBasenameNoExtension {
          final basenameWithoutExtension = path.basenameWithoutExtension(assetName);
          return basenameWithoutExtension;
        }
      
        /// The file extension name of the asset resource.
        String get fileExtname {
          final extension = path.extension(assetName);
          return extension;
        }
      
        /// The directory path name of the asset resource.
        String get fileDirname {
          var dirname = assetName;
          if (packageName != null) {
            final packageStr = "packages/$packageName/";
            dirname = dirname.replaceAll(packageStr, "");
          }
          final filenameStr = "$fileBasename/";
          dirname = dirname.replaceAll(filenameStr, "");
          return dirname;
        }
      }
// ignore: camel_case_types
      class _R_Image_AssetResource {
        const _R_Image_AssetResource();
      
  /// asset: assets/images/appIcon/appstore.png
      // ignore: non_constant_identifier_names
      final appstore = const AssetResource("assets/images/appIcon/appstore.png", packageName: null);
  /// asset: assets/images/appIcon/playstore.png
      // ignore: non_constant_identifier_names
      final playstore = const AssetResource("assets/images/appIcon/playstore.png", packageName: null);
  /// asset: assets/images/common/header_float_icon.jpg
      // ignore: non_constant_identifier_names
      final header_float_icon_jpg = const AssetResource("assets/images/common/header_float_icon.jpg", packageName: null);
  /// asset: assets/images/common/header_icon.png
      // ignore: non_constant_identifier_names
      final header_icon = const AssetResource("assets/images/common/header_icon.png", packageName: null);
  /// asset: assets/images/common/header_icon_rsz.png
      // ignore: non_constant_identifier_names
      final header_icon_rsz = const AssetResource("assets/images/common/header_icon_rsz.png", packageName: null);
  /// asset: assets/images/common/logo.jpg
      // ignore: non_constant_identifier_names
      final logo_jpg = const AssetResource("assets/images/common/logo.jpg", packageName: null);
  /// asset: assets/images/common/logo_150.jpg
      // ignore: non_constant_identifier_names
      final logo_150_jpg = const AssetResource("assets/images/common/logo_150.jpg", packageName: null);
  /// asset: assets/images/common/ouo.png
      // ignore: non_constant_identifier_names
      final ouo = const AssetResource("assets/images/common/ouo.png", packageName: null);
  /// asset: assets/images/dev/dev_avatar.png
      // ignore: non_constant_identifier_names
      final dev_avatar = const AssetResource("assets/images/dev/dev_avatar.png", packageName: null);
  /// asset: assets/images/game/machine/2bom.png
      // ignore: non_constant_identifier_names
      final a2bom = const AssetResource("assets/images/game/machine/2bom.png", packageName: null);
  /// asset: assets/images/game/machine/2chu.png
      // ignore: non_constant_identifier_names
      final a2chu = const AssetResource("assets/images/game/machine/2chu.png", packageName: null);
  /// asset: assets/images/game/machine/2dm.png
      // ignore: non_constant_identifier_names
      final a2dm = const AssetResource("assets/images/game/machine/2dm.png", packageName: null);
  /// asset: assets/images/game/machine/2mmdx.png
      // ignore: non_constant_identifier_names
      final a2mmdx = const AssetResource("assets/images/game/machine/2mmdx.png", packageName: null);
  /// asset: assets/images/game/machine/2nos.png
      // ignore: non_constant_identifier_names
      final a2nos = const AssetResource("assets/images/game/machine/2nos.png", packageName: null);
  /// asset: assets/images/game/machine/2tko.png
      // ignore: non_constant_identifier_names
      final a2tko = const AssetResource("assets/images/game/machine/2tko.png", packageName: null);
  /// asset: assets/images/game/machine/chu.png
      // ignore: non_constant_identifier_names
      final chu = const AssetResource("assets/images/game/machine/chu.png", packageName: null);
  /// asset: assets/images/game/machine/ddr.png
      // ignore: non_constant_identifier_names
      final ddr = const AssetResource("assets/images/game/machine/ddr.png", packageName: null);
  /// asset: assets/images/game/machine/gc.png
      // ignore: non_constant_identifier_names
      final gc = const AssetResource("assets/images/game/machine/gc.png", packageName: null);
  /// asset: assets/images/game/machine/ju.png
      // ignore: non_constant_identifier_names
      final ju = const AssetResource("assets/images/game/machine/ju.png", packageName: null);
  /// asset: assets/images/game/machine/mmdx.png
      // ignore: non_constant_identifier_names
      final mmdx = const AssetResource("assets/images/game/machine/mmdx.png", packageName: null);
  /// asset: assets/images/game/machine/nvsv.png
      // ignore: non_constant_identifier_names
      final nvsv = const AssetResource("assets/images/game/machine/nvsv.png", packageName: null);
  /// asset: assets/images/game/machine/pop.png
      // ignore: non_constant_identifier_names
      final pop = const AssetResource("assets/images/game/machine/pop.png", packageName: null);
  /// asset: assets/images/game/machine/sdvx.png
      // ignore: non_constant_identifier_names
      final sdvx = const AssetResource("assets/images/game/machine/sdvx.png", packageName: null);
  /// asset: assets/images/game/machine/tko.png
      // ignore: non_constant_identifier_names
      final tko = const AssetResource("assets/images/game/machine/tko.png", packageName: null);
  /// asset: assets/images/game/machine/wac.png
      // ignore: non_constant_identifier_names
      final wac = const AssetResource("assets/images/game/machine/wac.png", packageName: null);
  /// asset: assets/images/game/machine/x40chu.png
      // ignore: non_constant_identifier_names
      final x40chu = const AssetResource("assets/images/game/machine/x40chu.png", packageName: null);
  /// asset: assets/images/game/machine/x40ddr.png
      // ignore: non_constant_identifier_names
      final x40ddr = const AssetResource("assets/images/game/machine/x40ddr.png", packageName: null);
  /// asset: assets/images/game/machine/x40maidx.png
      // ignore: non_constant_identifier_names
      final x40maidx = const AssetResource("assets/images/game/machine/x40maidx.png", packageName: null);
  /// asset: assets/images/game/machine/x40sdvx.png
      // ignore: non_constant_identifier_names
      final x40sdvx = const AssetResource("assets/images/game/machine/x40sdvx.png", packageName: null);
  /// asset: assets/images/game/machine/x40tko.png
      // ignore: non_constant_identifier_names
      final x40tko = const AssetResource("assets/images/game/machine/x40tko.png", packageName: null);
  /// asset: assets/images/game/machine/x40wac.png
      // ignore: non_constant_identifier_names
      final x40wac = const AssetResource("assets/images/game/machine/x40wac.png", packageName: null);
  /// asset: assets/images/game/store/37656.jpg
      // ignore: non_constant_identifier_names
      final a37656_jpg = const AssetResource("assets/images/game/store/37656.jpg", packageName: null);
  /// asset: assets/images/game/store/37657.jpg
      // ignore: non_constant_identifier_names
      final a37657_jpg = const AssetResource("assets/images/game/store/37657.jpg", packageName: null);
  /// asset: assets/images/game/store/37658.jpg
      // ignore: non_constant_identifier_names
      final a37658_jpg = const AssetResource("assets/images/game/store/37658.jpg", packageName: null);
  /// asset: assets/images/game/store/x40mgs.jpg
      // ignore: non_constant_identifier_names
      final x40mgs_jpg = const AssetResource("assets/images/game/store/x40mgs.jpg", packageName: null);
  /// asset: assets/images/game/store/x50mgs.jpg
      // ignore: non_constant_identifier_names
      final x50mgs_jpg = const AssetResource("assets/images/game/store/x50mgs.jpg", packageName: null);
  /// asset: assets/images/gradeBox/chu_80.png
      // ignore: non_constant_identifier_names
      final chu_80 = const AssetResource("assets/images/gradeBox/chu_80.png", packageName: null);
  /// asset: assets/images/gradeBox/mayhem.png
      // ignore: non_constant_identifier_names
      final mayhem = const AssetResource("assets/images/gradeBox/mayhem.png", packageName: null);
  /// asset: assets/images/gradeBox/miku2nd.png
      // ignore: non_constant_identifier_names
      final miku2nd = const AssetResource("assets/images/gradeBox/miku2nd.png", packageName: null);
  /// asset: assets/images/gradeBox/mmdxc.jpg
      // ignore: non_constant_identifier_names
      final mmdxc_jpg = const AssetResource("assets/images/gradeBox/mmdxc.jpg", packageName: null);
  /// asset: assets/images/gradeBox/ouo_80.png
      // ignore: non_constant_identifier_names
      final ouo_80 = const AssetResource("assets/images/gradeBox/ouo_80.png", packageName: null);
  /// asset: assets/images/gradeBox/sdvx10th.jpg
      // ignore: non_constant_identifier_names
      final sdvx10th_jpg = const AssetResource("assets/images/gradeBox/sdvx10th.jpg", packageName: null);
  /// asset: assets/images/gradeBox/vvelcome.png
      // ignore: non_constant_identifier_names
      final vvelcome = const AssetResource("assets/images/gradeBox/vvelcome.png", packageName: null);
  /// asset: assets/images/home/mari_level/ouo.png
      // ignore: non_constant_identifier_names
      final ouo$1 = const AssetResource("assets/images/home/mari_level/ouo.png", packageName: null);
  /// asset: assets/images/home/top.png
      // ignore: non_constant_identifier_names
      final top = const AssetResource("assets/images/home/top.png", packageName: null);
  /// asset: assets/images/home/vts.png
      // ignore: non_constant_identifier_names
      final vts = const AssetResource("assets/images/home/vts.png", packageName: null);
  /// asset: assets/images/login/login_banner.jpg
      // ignore: non_constant_identifier_names
      final login_banner_jpg = const AssetResource("assets/images/login/login_banner.jpg", packageName: null);
      }
// ignore: camel_case_types
    class _R_Svg_AssetResource {
      const _R_Svg_AssetResource();
    
  /// asset: assets/images/collab/shop-solid.svg
      // ignore: non_constant_identifier_names
      final shop_solid = const AssetResource("assets/images/collab/shop-solid.svg", packageName: null);
  /// asset: assets/images/common/spinner-solid.svg
      // ignore: non_constant_identifier_names
      final spinner_solid = const AssetResource("assets/images/common/spinner-solid.svg", packageName: null);
  /// asset: assets/images/common/torii.svg
      // ignore: non_constant_identifier_names
      final torii = const AssetResource("assets/images/common/torii.svg", packageName: null);
  /// asset: assets/images/home/bolt-solid.svg
      // ignore: non_constant_identifier_names
      final bolt_solid = const AssetResource("assets/images/home/bolt-solid.svg", packageName: null);
  /// asset: assets/images/home/heart-regular.svg
      // ignore: non_constant_identifier_names
      final heart_regular = const AssetResource("assets/images/home/heart-regular.svg", packageName: null);
  /// asset: assets/images/home/heart-solid.svg
      // ignore: non_constant_identifier_names
      final heart_solid = const AssetResource("assets/images/home/heart-solid.svg", packageName: null);
  /// asset: assets/images/home/shirt-solid.svg
      // ignore: non_constant_identifier_names
      final shirt_solid = const AssetResource("assets/images/home/shirt-solid.svg", packageName: null);
  /// asset: assets/images/quest/stamp.svg
      // ignore: non_constant_identifier_names
      final stamp = const AssetResource("assets/images/quest/stamp.svg", packageName: null);
    }
// ignore: camel_case_types
    class _R_Text_AssetResource {
      const _R_Text_AssetResource();
    
  /// asset: assets/texts/avater.txt
      // ignore: non_constant_identifier_names
      final avater_txt = const AssetResource("assets/texts/avater.txt", packageName: null);
  /// asset: assets/texts/license.txt
      // ignore: non_constant_identifier_names
      final license_txt = const AssetResource("assets/texts/license.txt", packageName: null);
    }
/// This `_R_Image` class is generated and contains references to static non-svg type image asset resources.
    // ignore: camel_case_types
    class _R_Image {
      const _R_Image();
    
      final asset = const _R_Image_AssetResource();
    
  /// asset: assets/images/appIcon/appstore.png
      // ignore: non_constant_identifier_names
      AssetImage appstore() {
        return AssetImage(asset.appstore.keyName);
      }
  /// asset: assets/images/appIcon/playstore.png
      // ignore: non_constant_identifier_names
      AssetImage playstore() {
        return AssetImage(asset.playstore.keyName);
      }
  /// asset: assets/images/common/header_float_icon.jpg
      // ignore: non_constant_identifier_names
      AssetImage header_float_icon_jpg() {
        return AssetImage(asset.header_float_icon_jpg.keyName);
      }
  /// asset: assets/images/common/header_icon.png
      // ignore: non_constant_identifier_names
      AssetImage header_icon() {
        return AssetImage(asset.header_icon.keyName);
      }
  /// asset: assets/images/common/header_icon_rsz.png
      // ignore: non_constant_identifier_names
      AssetImage header_icon_rsz() {
        return AssetImage(asset.header_icon_rsz.keyName);
      }
  /// asset: assets/images/common/logo.jpg
      // ignore: non_constant_identifier_names
      AssetImage logo_jpg() {
        return AssetImage(asset.logo_jpg.keyName);
      }
  /// asset: assets/images/common/logo_150.jpg
      // ignore: non_constant_identifier_names
      AssetImage logo_150_jpg() {
        return AssetImage(asset.logo_150_jpg.keyName);
      }
  /// asset: assets/images/common/ouo.png
      // ignore: non_constant_identifier_names
      AssetImage ouo() {
        return AssetImage(asset.ouo.keyName);
      }
  /// asset: assets/images/dev/dev_avatar.png
      // ignore: non_constant_identifier_names
      AssetImage dev_avatar() {
        return AssetImage(asset.dev_avatar.keyName);
      }
  /// asset: assets/images/game/machine/2bom.png
      // ignore: non_constant_identifier_names
      AssetImage a2bom() {
        return AssetImage(asset.a2bom.keyName);
      }
  /// asset: assets/images/game/machine/2chu.png
      // ignore: non_constant_identifier_names
      AssetImage a2chu() {
        return AssetImage(asset.a2chu.keyName);
      }
  /// asset: assets/images/game/machine/2dm.png
      // ignore: non_constant_identifier_names
      AssetImage a2dm() {
        return AssetImage(asset.a2dm.keyName);
      }
  /// asset: assets/images/game/machine/2mmdx.png
      // ignore: non_constant_identifier_names
      AssetImage a2mmdx() {
        return AssetImage(asset.a2mmdx.keyName);
      }
  /// asset: assets/images/game/machine/2nos.png
      // ignore: non_constant_identifier_names
      AssetImage a2nos() {
        return AssetImage(asset.a2nos.keyName);
      }
  /// asset: assets/images/game/machine/2tko.png
      // ignore: non_constant_identifier_names
      AssetImage a2tko() {
        return AssetImage(asset.a2tko.keyName);
      }
  /// asset: assets/images/game/machine/chu.png
      // ignore: non_constant_identifier_names
      AssetImage chu() {
        return AssetImage(asset.chu.keyName);
      }
  /// asset: assets/images/game/machine/ddr.png
      // ignore: non_constant_identifier_names
      AssetImage ddr() {
        return AssetImage(asset.ddr.keyName);
      }
  /// asset: assets/images/game/machine/gc.png
      // ignore: non_constant_identifier_names
      AssetImage gc() {
        return AssetImage(asset.gc.keyName);
      }
  /// asset: assets/images/game/machine/ju.png
      // ignore: non_constant_identifier_names
      AssetImage ju() {
        return AssetImage(asset.ju.keyName);
      }
  /// asset: assets/images/game/machine/mmdx.png
      // ignore: non_constant_identifier_names
      AssetImage mmdx() {
        return AssetImage(asset.mmdx.keyName);
      }
  /// asset: assets/images/game/machine/nvsv.png
      // ignore: non_constant_identifier_names
      AssetImage nvsv() {
        return AssetImage(asset.nvsv.keyName);
      }
  /// asset: assets/images/game/machine/pop.png
      // ignore: non_constant_identifier_names
      AssetImage pop() {
        return AssetImage(asset.pop.keyName);
      }
  /// asset: assets/images/game/machine/sdvx.png
      // ignore: non_constant_identifier_names
      AssetImage sdvx() {
        return AssetImage(asset.sdvx.keyName);
      }
  /// asset: assets/images/game/machine/tko.png
      // ignore: non_constant_identifier_names
      AssetImage tko() {
        return AssetImage(asset.tko.keyName);
      }
  /// asset: assets/images/game/machine/wac.png
      // ignore: non_constant_identifier_names
      AssetImage wac() {
        return AssetImage(asset.wac.keyName);
      }
  /// asset: assets/images/game/machine/x40chu.png
      // ignore: non_constant_identifier_names
      AssetImage x40chu() {
        return AssetImage(asset.x40chu.keyName);
      }
  /// asset: assets/images/game/machine/x40ddr.png
      // ignore: non_constant_identifier_names
      AssetImage x40ddr() {
        return AssetImage(asset.x40ddr.keyName);
      }
  /// asset: assets/images/game/machine/x40maidx.png
      // ignore: non_constant_identifier_names
      AssetImage x40maidx() {
        return AssetImage(asset.x40maidx.keyName);
      }
  /// asset: assets/images/game/machine/x40sdvx.png
      // ignore: non_constant_identifier_names
      AssetImage x40sdvx() {
        return AssetImage(asset.x40sdvx.keyName);
      }
  /// asset: assets/images/game/machine/x40tko.png
      // ignore: non_constant_identifier_names
      AssetImage x40tko() {
        return AssetImage(asset.x40tko.keyName);
      }
  /// asset: assets/images/game/machine/x40wac.png
      // ignore: non_constant_identifier_names
      AssetImage x40wac() {
        return AssetImage(asset.x40wac.keyName);
      }
  /// asset: assets/images/game/store/37656.jpg
      // ignore: non_constant_identifier_names
      AssetImage a37656_jpg() {
        return AssetImage(asset.a37656_jpg.keyName);
      }
  /// asset: assets/images/game/store/37657.jpg
      // ignore: non_constant_identifier_names
      AssetImage a37657_jpg() {
        return AssetImage(asset.a37657_jpg.keyName);
      }
  /// asset: assets/images/game/store/37658.jpg
      // ignore: non_constant_identifier_names
      AssetImage a37658_jpg() {
        return AssetImage(asset.a37658_jpg.keyName);
      }
  /// asset: assets/images/game/store/x40mgs.jpg
      // ignore: non_constant_identifier_names
      AssetImage x40mgs_jpg() {
        return AssetImage(asset.x40mgs_jpg.keyName);
      }
  /// asset: assets/images/game/store/x50mgs.jpg
      // ignore: non_constant_identifier_names
      AssetImage x50mgs_jpg() {
        return AssetImage(asset.x50mgs_jpg.keyName);
      }
  /// asset: assets/images/gradeBox/chu_80.png
      // ignore: non_constant_identifier_names
      AssetImage chu_80() {
        return AssetImage(asset.chu_80.keyName);
      }
  /// asset: assets/images/gradeBox/mayhem.png
      // ignore: non_constant_identifier_names
      AssetImage mayhem() {
        return AssetImage(asset.mayhem.keyName);
      }
  /// asset: assets/images/gradeBox/miku2nd.png
      // ignore: non_constant_identifier_names
      AssetImage miku2nd() {
        return AssetImage(asset.miku2nd.keyName);
      }
  /// asset: assets/images/gradeBox/mmdxc.jpg
      // ignore: non_constant_identifier_names
      AssetImage mmdxc_jpg() {
        return AssetImage(asset.mmdxc_jpg.keyName);
      }
  /// asset: assets/images/gradeBox/ouo_80.png
      // ignore: non_constant_identifier_names
      AssetImage ouo_80() {
        return AssetImage(asset.ouo_80.keyName);
      }
  /// asset: assets/images/gradeBox/sdvx10th.jpg
      // ignore: non_constant_identifier_names
      AssetImage sdvx10th_jpg() {
        return AssetImage(asset.sdvx10th_jpg.keyName);
      }
  /// asset: assets/images/gradeBox/vvelcome.png
      // ignore: non_constant_identifier_names
      AssetImage vvelcome() {
        return AssetImage(asset.vvelcome.keyName);
      }
  /// asset: assets/images/home/mari_level/ouo.png
      // ignore: non_constant_identifier_names
      AssetImage ouo$1() {
        return AssetImage(asset.ouo$1.keyName);
      }
  /// asset: assets/images/home/top.png
      // ignore: non_constant_identifier_names
      AssetImage top() {
        return AssetImage(asset.top.keyName);
      }
  /// asset: assets/images/home/vts.png
      // ignore: non_constant_identifier_names
      AssetImage vts() {
        return AssetImage(asset.vts.keyName);
      }
  /// asset: assets/images/login/login_banner.jpg
      // ignore: non_constant_identifier_names
      AssetImage login_banner_jpg() {
        return AssetImage(asset.login_banner_jpg.keyName);
      }
    }
/// This `_R_Svg` class is generated and contains references to static svg type image asset resources.
    // ignore: camel_case_types
    class _R_Svg {
      const _R_Svg();
    
      final asset = const _R_Svg_AssetResource();
    
  /// asset: assets/images/collab/shop-solid.svg
      // ignore: non_constant_identifier_names
      AssetSvg shop_solid({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.shop_solid.keyName, width: width, height: height);
        return imageProvider;
      }
  /// asset: assets/images/common/spinner-solid.svg
      // ignore: non_constant_identifier_names
      AssetSvg spinner_solid({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.spinner_solid.keyName, width: width, height: height);
        return imageProvider;
      }
  /// asset: assets/images/common/torii.svg
      // ignore: non_constant_identifier_names
      AssetSvg torii({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.torii.keyName, width: width, height: height);
        return imageProvider;
      }
  /// asset: assets/images/home/bolt-solid.svg
      // ignore: non_constant_identifier_names
      AssetSvg bolt_solid({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.bolt_solid.keyName, width: width, height: height);
        return imageProvider;
      }
  /// asset: assets/images/home/heart-regular.svg
      // ignore: non_constant_identifier_names
      AssetSvg heart_regular({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.heart_regular.keyName, width: width, height: height);
        return imageProvider;
      }
  /// asset: assets/images/home/heart-solid.svg
      // ignore: non_constant_identifier_names
      AssetSvg heart_solid({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.heart_solid.keyName, width: width, height: height);
        return imageProvider;
      }
  /// asset: assets/images/home/shirt-solid.svg
      // ignore: non_constant_identifier_names
      AssetSvg shirt_solid({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.shirt_solid.keyName, width: width, height: height);
        return imageProvider;
      }
  /// asset: assets/images/quest/stamp.svg
      // ignore: non_constant_identifier_names
      AssetSvg stamp({required double width, required double height}) {
        final imageProvider = AssetSvg(asset.stamp.keyName, width: width, height: height);
        return imageProvider;
      }
    }
/// This `_R_Text` class is generated and contains references to static text asset resources.
    // ignore: camel_case_types
    class _R_Text {
      const _R_Text();
    
      final asset = const _R_Text_AssetResource();
    
  /// asset: assets/texts/avater.txt
      // ignore: non_constant_identifier_names
      Future<String> avater_txt() {
        final str = rootBundle.loadString(asset.avater_txt.keyName);
        return str;
      }
  /// asset: assets/texts/license.txt
      // ignore: non_constant_identifier_names
      Future<String> license_txt() {
        final str = rootBundle.loadString(asset.license_txt.keyName);
        return str;
      }
    }
/// This `_R_FontFamily` class is generated and contains references to static font asset resources.
    // ignore: camel_case_types
    class _R_FontFamily {
      const _R_FontFamily();
    
  /// font family: NotoSansJP
      // ignore: non_constant_identifier_names
      final notoSansJP = "NotoSansJP";
    }