import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../../shared/models/issues_model.dart';
import '../../shared/utils/util_methods.dart';
import '../../shared/utils/static_data.dart';
import '../api/all_issues_api.dart';

class AllIssuesProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  final List<Issue> _allIssuesList = [];
  List<Issue> get allIssuesList => [..._allIssuesList];
  void setLoading(bool loadingBool) {
    _isLoading = loadingBool;
    notifyListeners();
  }

  void setError(bool errorBool) {
    _isError = errorBool;
    notifyListeners();
  }

  Future<void> getAllIssues(String authToken) async {
    dev.log("get All Issues called", name: "All Issues");
    if (isError) setError(false);
    if (!isLoading) setLoading(true);
    final res = await allIssueApiCallService(authToken);
    if (res == null) {
      setError(true);
      setLoading(false);
      return;
    }

    _allIssuesList.clear();
    _allIssuesList.addAll(res);
    setLoading(false);
  }

  Map<String, bool> sortedStatusMap = {
    CREATION_DATE: false,
    UPDATE_DATE: false,
    CREATED_BY: false,
    PRIORITY: false,
    STATUS: false,
  };

  void sortIssuesByCreationDate() {
    sortedStatusMap[CREATION_DATE] = !sortedStatusMap[CREATION_DATE]!;
    sortByCreationDate(_allIssuesList, dec: sortedStatusMap[CREATION_DATE]!);
    notifyListeners();
  }

  void sortIssuesByUpdateDate() {
    sortedStatusMap[UPDATE_DATE] = !sortedStatusMap[UPDATE_DATE]!;
    sortByUpdatedDate(_allIssuesList, dec: sortedStatusMap[UPDATE_DATE]!);
    notifyListeners();
  }

  void sortIssuesByPriority() {
    sortedStatusMap[PRIORITY] = !sortedStatusMap[PRIORITY]!;
    sortByPriority(_allIssuesList, dec: sortedStatusMap[PRIORITY]!);
    notifyListeners();
  }

  void sortIssuesByStatus() {
    sortedStatusMap[STATUS] = !sortedStatusMap[STATUS]!;
    sortByStatus(_allIssuesList, dec: sortedStatusMap[STATUS]!);
    notifyListeners();
  }

  void sortIssuesByOwner() {
    sortedStatusMap[CREATED_BY] = !sortedStatusMap[CREATED_BY]!;
    sortByCreatedBy(_allIssuesList, dec: sortedStatusMap[CREATED_BY]!);
    notifyListeners();
  }
}
