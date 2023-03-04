import 'package:dio/dio.dart';

import 'dart:developer' as dev;
import '../../shared/models/issues_model.dart';
import '../../static_data.dart';

Future<List<Issue>?> allIssueApiCallService(String authToken) async {
  List<Issue> _allIssueList = [];
  try {
    dev.log("myIssueApiCall called", name: "All Issues API");
    final res = await Dio().get(
      "$host/api/viewIssue",
      data: {"token": authToken},
    );
    dev.log(res.statusCode.toString(), name: "All Issues resCode");
    if (res.statusCode != 200) throw Exception("Invalid Status Code");
    if (res.data["success"] != true) throw Exception("Invalid Status Code");
    _allIssueList.clear();
    List myIssuesDataList = res.data["data"];
    for (var element in myIssuesDataList) {
      _allIssueList.add(Issue.fromJson(element));
    }
  } catch (e) {
    dev.log(e.toString(), name: "All Issues Exception");
    return null;
  }
  return [..._allIssueList];
}

Future<void> deleteIssueService(
    {required String issueId, required String authToken}) async {
  try {
    await Dio().delete(
      "$host/api/deleteIssue/$issueId",
      data: {"token": authToken},
    );
  } catch (e) {
    dev.log(e.toString(), name: "All Issues Exception while delete");
  }
}
