import 'package:flutter/material.dart';

// TODO: merge with Game insert service
class CoinInsertionProvider extends ChangeNotifier {
  bool _isCoinInserted = false;

  bool get isCoinInserted => _isCoinInserted;

  set isCoinInserted(bool value) {
    _isCoinInserted = value;
    notifyListeners();
  }
}
