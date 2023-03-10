import 'package:dio/dio.dart';
import 'dart:developer' as dev;

import '../../shared/models/issues_model.dart';
import '../../shared/utils/static_data.dart';

Future<List<Issue>?> issuesAssignedToMeService(String authToken) async {
  List<Issue> _issuesAssignedToMeList = [];
  try {
    dev.log("myIssueApiCall called", name: "My Issues API");
    final res = await Dio().get(
      "$host/userAssignedIssues",
      data: {"token": authToken},
    );
    dev.log(res.statusCode.toString(), name: "Issues Assigned To Me Res");
    if (!(res.statusCode != 201 || res.statusCode != 200)) {
      throw Exception("Invalid Status Code");
    }

    _issuesAssignedToMeList.clear();

    List<dynamic>? myIssuesDataList = res.data["data"];
    if (myIssuesDataList == null) return null;
    if (myIssuesDataList.isEmpty) {
      _issuesAssignedToMeList.clear();
      return [];
    }
    for (var element in myIssuesDataList) {
      try {
        _issuesAssignedToMeList.add(Issue.fromJson(element));
      } catch (e) {}
    }
  } catch (e) {
    dev.log(e.toString(), name: "Issue Assigned to me Exception");
    return null;
  }
  return [..._issuesAssignedToMeList];
}
