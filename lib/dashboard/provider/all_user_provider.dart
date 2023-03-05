import 'dart:developer';

import 'package:brd_issue_tracker/dashboard/api/all_users_api.dart';
import 'package:flutter/material.dart';

import '../../shared/models/user_model.dart';

class AllUserProvider with ChangeNotifier {
  Map<String, List<UserModel>> _userMap = {};
  bool _isLoading = true;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  Map<String, List<UserModel>> get userMap => {..._userMap};
  void setLoading(bool loadingBool) {
    _isLoading = loadingBool;
    notifyListeners();
  }

  void setError(bool errorBool) {
    _isError = errorBool;
    notifyListeners();
  }

  void setUserMap(Map<String, List<UserModel>> userMap) {
    _userMap.clear();
    _userMap = userMap;
    notifyListeners();
  }

  Future<void> getAllUsers() async {
    log("All User Api Called", name: "All User Api");
    final res = await allUsersApi();
    if (res == null) {
      setError(true);
      setLoading(false);
      return;
    }
    setUserMap(res);
    setLoading(false);
    setError(false);
  }
}
