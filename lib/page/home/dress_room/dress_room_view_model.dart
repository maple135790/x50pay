import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/models/avatar/avatar.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class DressRoomViewModel extends ChangeNotifier {
  final MainRepository repository;

  DressRoomViewModel({required this.repository});

  static const avatarUrl = 'https://pay.x50.fun/api/v1/list/avater';

  List<Avatar> _avatars = <Avatar>[];
  List<Avatar> get avatars => List.unmodifiable(_avatars);

  String _loadingStatus = '';
  String get loadingStatus => _loadingStatus;

  set loadingStatus(String value) {
    _loadingStatus = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _selectedAvatar;
  String? get selectedId => _selectedAvatar;
  set selectedId(String? value) {
    if (_selectedAvatar == value) {
      _selectedAvatar = null;
    } else {
      _selectedAvatar = value;
    }
    notifyListeners();
  }

  Future<List<Avatar>> getAvatars() async {
    try {
      loadingStatus = '取得更衣室的所有衣服中...';
      final response = await repository.getAvatar();

      if (response.result.isError) {
        throw Exception('statusCode:');
      }
      _avatars = response.result.successData;
    } catch (e) {
      log('', name: 'DressRoomViewModel init', error: e);
      loadingStatus = '錯誤';
    }
    return avatars;
  }

  Future<bool> setAvatar() async {
    if (selectedId == null) return false;

    _isLoading = true;
    final res = await repository.setAvatar(selectedId!);
    _isLoading = false;

    return res.result.isSuccess;
  }
}
