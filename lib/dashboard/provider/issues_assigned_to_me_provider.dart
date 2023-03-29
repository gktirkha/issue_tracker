import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import '../../shared/utils/static_data.dart';
import '../../shared/utils/util_methods.dart';
import '../api/issue_assigned_to_me_api.dart';
import '../../shared/models/issues_model.dart';

class IssuesAssignedToMeProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  final List<Issue> _issuesAssignedToMeList = [];
  List<Issue> get issuesAssignedToMeList => [..._issuesAssignedToMeList];
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
    _issuesAssignedToMeList.clear();
    _issuesAssignedToMeList.addAll(res);
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
    sortByCreationDate(_issuesAssignedToMeList,
        dec: sortedStatusMap[CREATION_DATE]!);
    notifyListeners();
  }

  void sortIssuesByUpdateDate() {
    sortedStatusMap[UPDATE_DATE] = !sortedStatusMap[UPDATE_DATE]!;
    sortByUpdatedDate(_issuesAssignedToMeList,
        dec: sortedStatusMap[UPDATE_DATE]!);
    notifyListeners();
  }

  void sortIssuesByPriority() {
    sortedStatusMap[PRIORITY] = !sortedStatusMap[PRIORITY]!;
    sortByPriority(_issuesAssignedToMeList, dec: sortedStatusMap[PRIORITY]!);
    notifyListeners();
  }

  void sortIssuesByStatus() {
    sortedStatusMap[STATUS] = !sortedStatusMap[STATUS]!;
    sortByStatus(_issuesAssignedToMeList, dec: sortedStatusMap[STATUS]!);
    notifyListeners();
  }

  void sortIssuesByOwner() {
    sortedStatusMap[CREATED_BY] = !sortedStatusMap[CREATED_BY]!;
    sortByCreatedBy(_issuesAssignedToMeList, dec: sortedStatusMap[CREATED_BY]!);
    notifyListeners();
  }
}
