import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/r.g.dart';

/// 紀錄頁面的mixin
///
/// 用於簡化紀錄頁面，提供標準的頁面結構。
mixin RecordPageMixin<M, T extends StatefulWidget> on BaseStatefulState<T> {
  /// 頁面標題
  String pageTitle();

  /// 取得紀錄的方法，通常是呼叫 [SettingsViewModel] 的方法
  Future<M> getRecord();

  /// 建立 [DataTable] 的row
  List<DataRow> buildRows(M model);

  /// 建立 [DataTable] 的column
  List<DataColumn> buildColumns();

  /// 檢查紀錄是否含有資料，通常是檢查 `model.logs.isNotEmpty`
  bool hasData(M model);

  late final M _model;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, vm, child) {
        return Material(
          child: FutureBuilder(
            future: getRecord(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (!snapshot.hasData || snapshot.hasError) {
                return Center(child: Text(serviceErrorText));
              }
              _model = snapshot.data as M;
              return _body();
            },
          ),
        );
      },
    );
  }

  Widget _body() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  border: Border.all(color: Themes.borderColor, width: 1)),
              child: Row(
                children: [
                  CircleAvatar(
                      foregroundImage: R.image.logo_150_jpg(), radius: 29),
                  const SizedBox(width: 16.8),
                  Expanded(
                    child: Text(
                      pageTitle(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            hasData(_model)
                ? ShaderMask(
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.white,
                          Colors.white,
                        ],
                        stops: [0.0, 0.02, 0.1, 0.9, 0.98, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DataTable(
                            border: TableBorder.all(color: Themes.borderColor),
                            dataRowMaxHeight: 60,
                            horizontalMargin: 12,
                            columnSpacing: 25,
                            columns: buildColumns(),
                            rows: buildRows(_model),
                          ),
                        ),
                      ),
                    ),
                  )
                : const Center(child: Text('無資料')),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
