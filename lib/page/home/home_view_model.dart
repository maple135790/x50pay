import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/r.g.dart';

class HomeViewModel extends BaseViewModel {
  Future<ImageProvider<Object>> getUserImage() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return R.image.dev_avatar();
  }

  Future<String> getUserName() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return '鯖缶';
  }

  Future<String> getUserId() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return '00938 (已驗證)';
  }

  Future<bool> getMPassStatus() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return true;
  }

  Future<int> getPointCount() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return 222;
  }

  Future<int> getTicketCount() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return 9;
  }
}
