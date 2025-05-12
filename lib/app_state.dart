import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _isAdmin = kIsWeb;

  bool get isAdmin => _isAdmin;

  void toggleView() {
    _isAdmin = !_isAdmin;
    notifyListeners();
  }
}
