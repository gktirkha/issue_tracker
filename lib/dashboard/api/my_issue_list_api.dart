import 'package:dio/dio.dart';

import 'dart:developer' as dev;
import '../../shared/models/issues_model.dart';
import '../../static_data.dart';

Future<List<Issue>?> myIssueApiCallService(String authToken) async {
  List<Issue> _myIssueList = [];
  try {
    dev.log("myIssueApiCall called", name: "My Issues API");
    final res = await Dio().get(
      "$host/api/userIssues",
      data: {"token": authToken},
    );
    dev.log(res.statusCode.toString(), name: "My Issue resCode");
    if (res.statusCode != 201) throw Exception("Invalid Status Code");
    if (res.data["success"] != true) throw Exception("Invalid Status Code");
    _myIssueList.clear();
    List myIssuesDataList = res.data["data"];
    for (var element in myIssuesDataList) {
      _myIssueList.add(Issue.fromJson(element));
    }
  } catch (e) {
    dev.log(e.toString(), name: "My Issue Exception");
    return null;
  }
  return [..._myIssueList];
}

Future<void> deleteIssueService(
    {required String issueId, required String authToken}) async {
  try {
    await Dio().delete(
      "$host/api/deleteIssue/$issueId",
      data: {"token": authToken},
    );
  } catch (e) {
    dev.log(e.toString(), name: "My Issue Exception while delete");
  }
}
