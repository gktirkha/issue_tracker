import 'dart:developer';
import '../api/all_users_api.dart';
import 'package:flutter/material.dart';
import '../../shared/models/user_model.dart';

class AllUserProvider with ChangeNotifier {
  Map<String, bool> sortedStatusMap = {
    "CREATION_DATE": false,
    "NAME": false,
    "ASSIGN_COUNT": false,
    "DEPARTMENT": false,
    "isAdmin": false,
  };

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

    if (isError) setError(false);
    if (!isLoading) setLoading(true);
    final res = await allUsersApi(token);
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

  void sortByCreationDate() {
    bool dec = sortedStatusMap["CREATION_DATE"]!;
    sortedStatusMap["CREATION_DATE"] = !dec;
    _userList.sort(
      dec
          ? (a, b) => a.createdAt!.compareTo(b.createdAt!)
          : (b, a) => a.createdAt!.compareTo(b.createdAt!),
    );
    notifyListeners();
  }

  void sortByName() {
    bool dec = sortedStatusMap["NAME"]!;
    sortedStatusMap["NAME"] = !dec;
    _userList.sort(
      dec
          ? (a, b) => a.name.compareTo(b.name)
          : (b, a) => a.name.compareTo(b.name),
    );
    notifyListeners();
  }

  void sortByDepartment() {
    bool dec = sortedStatusMap["DEPARTMENT"]!;
    sortedStatusMap["DEPARTMENT"] = !dec;
    _userList.sort(
      dec
          ? (a, b) => a.department.compareTo(b.department)
          : (b, a) => a.department.compareTo(b.department),
    );
    notifyListeners();
  }

  void sortByAssignCount() {
    bool dec = sortedStatusMap["ASSIGN_COUNT"]!;
    sortedStatusMap["ASSIGN_COUNT"] = !dec;
    _userList.sort(
      dec
          ? (a, b) => a.assignCount!.compareTo(b.assignCount!)
          : (b, a) => a.assignCount!.compareTo(b.assignCount!),
    );
    notifyListeners();
  }

  void sortByAdminStatus() {
    bool dec = sortedStatusMap["isAdmin"]!;
    sortedStatusMap["isAdmin"] = !dec;
    _userList.sort(
      dec
          ? (a, b) => (a.isAdmin == b.isAdmin ? 0 : (a.isAdmin ? 1 : -1))
          : (b, a) => (a.isAdmin == b.isAdmin ? 0 : (a.isAdmin ? 1 : -1)),
    );
    notifyListeners();
  }
}
