import 'package:flutter/cupertino.dart';

class AuthenticateController with ChangeNotifier {
  bool _showSignIn = true, _isLoading = false;
  bool get showSignIn => _showSignIn;
  bool get isLoading => _isLoading;
  void toggleSignIn() {
    _showSignIn = !_showSignIn;
    notifyListeners();
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
