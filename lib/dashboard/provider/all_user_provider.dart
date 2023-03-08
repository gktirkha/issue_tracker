import 'dart:developer';
import 'package:brd_issue_tracker/dashboard/api/all_users_api.dart';
import 'package:flutter/material.dart';
import '../../shared/models/user_model.dart';

class AllUserProvider with ChangeNotifier {
  Map<String, List<UserModel>> _userMap = {};
  final List<UserModel> _userList = [];
  bool _isLoading = true;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  List<UserModel> get userList => _userList;

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

  void setUserList(Map<String, List<UserModel>> userMap) {
    _userList.clear();
    userMap.forEach((key, value) {
      _userList.addAll(value);
    });
    notifyListeners();
  }

  Future<void> getAllUsers(String token) async {
    log("All User Api Called", name: "All User Api");
    final res = await allUsersApi(token);
    if (isError) setError(false);
    if (!isLoading) setLoading(true);
    if (res == null) {
      setError(true);
      setLoading(false);
      return;
    }
    setUserMap(res);
    setUserList(res);
    setLoading(false);
    setError(false);
  }
}
