import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../../shared/models/issues_model.dart';
import '../api/issue_assigned_to_me_api.dart';

class IssuesAssignedToMeProvider with ChangeNotifier {
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

  Future<void> getIssuesAssignedToMe(String authToken) async {
    dev.log("getMyIssues called", name: "My Issues");
    if (isError) setError(false);
    if (!isLoading) setLoading(true);
    final res = await issuesAssignedToMeService(authToken);

    if (res == null) {
      setError(true);
      setLoading(false);
      return;
    }
    _myIssuesList.clear();
    _myIssuesList.addAll(res);
    setLoading(false);
  }
}
