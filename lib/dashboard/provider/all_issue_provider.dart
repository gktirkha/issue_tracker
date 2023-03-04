import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../../shared/models/issues_model.dart';
import '../api/all_issues_api.dart';

class AllIssuesProvider with ChangeNotifier {
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

  Future<void> getAllIssues(String authToken) async {
    dev.log("get All Issues called", name: "All Issues");
    if (isError) setError(false);
    final res = await allIssueApiCallService(authToken);
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
}
