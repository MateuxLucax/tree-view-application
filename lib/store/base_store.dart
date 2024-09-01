import 'package:flutter/material.dart';

class BaseStore extends ChangeNotifier {
  bool _mounted = true;
  bool get mounted => _mounted;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) super.notifyListeners();
  }
}
