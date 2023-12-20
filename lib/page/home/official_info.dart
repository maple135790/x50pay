import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/r.g.dart';

class OfficialInfo extends StatelessWidget {
  /// 官方資訊區
  ///
  /// 包含官方資訊的圖片，點擊圖片後會跳轉到該活動的頁面
  /// 通常是真璃的 youtube 頻道，及 X50 的 youtube 頻道
  const OfficialInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    Image(
                      image: R.image.vts(),
                      fit: BoxFit.fill,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            launchUrlString(
                                'https://www.youtube.com/channel/UCEbHRn4kPMzODDgsMwGhYVQ',
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                        ),
                      ),
                    ),
                  ],
                ))),
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    Image(
                      image: R.image.top(),
                      fit: BoxFit.fill,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            launchUrlString(
                                'https://www.youtube.com/c/X50MusicGameStation-onAir',
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                        ),
                      ),
                    ),
                  ],
                )))
      ],
    );
  }
}
