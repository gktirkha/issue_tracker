import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../../shared/models/issues_model.dart';
import '../../shared/util.dart';
import '../../static_data.dart';
import '../api/issues_created_by_me_api.dart';

class IssuesCreatedByMeProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  final List<Issue> _myIssuesList = [];
  List<Issue> get myIssuesList => [..._myIssuesList];
  void setLoading(bool loadingBool) {
    _isLoading = loadingBool;
    notifyListeners();
  }

  void setError(bool errorBool) {
    _isError = errorBool;
    notifyListeners();
  }

  Future<void> getMyIssues(String authToken) async {
    dev.log("getMyIssues called", name: "My Issues");
    if (isError) setError(false);
    if (!isLoading) setLoading(true);
    final res = await issuesCreatedByMeService(authToken);
    if (res == null) {
      setError(true);
      setLoading(false);
      return;
    }

    _myIssuesList.clear();
    _myIssuesList.addAll(res);
    setLoading(false);
  }

  Future<void> deleteIssue(
      {required String issueId, required String authToken}) async {
    await deleteIssueService(issueId: issueId, authToken: authToken);
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
    sortByCreationDate(_myIssuesList, dec: sortedStatusMap[CREATION_DATE]!);
    notifyListeners();
  }

  void sortIssuesByUpdateDate() {
    sortedStatusMap[UPDATE_DATE] = !sortedStatusMap[UPDATE_DATE]!;
    sortByUpdatedDate(_myIssuesList, dec: sortedStatusMap[UPDATE_DATE]!);
    notifyListeners();
  }

  void sortIssuesByPriority() {
    sortedStatusMap[PRIORITY] = !sortedStatusMap[PRIORITY]!;
    sortByPriority(_myIssuesList, dec: sortedStatusMap[PRIORITY]!);
    notifyListeners();
  }

  void sortIssuesByStatus() {
    sortedStatusMap[STATUS] = !sortedStatusMap[STATUS]!;
    sortByStatus(_myIssuesList, dec: sortedStatusMap[STATUS]!);
    notifyListeners();
  }

  void sortIssuesByOwner() {
    sortedStatusMap[CREATED_BY] = !sortedStatusMap[CREATED_BY]!;
    sortByCreatedBy(_myIssuesList, dec: sortedStatusMap[CREATED_BY]!);
    notifyListeners();
  }
}
