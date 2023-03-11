import 'package:dio/dio.dart';

import 'dart:developer' as dev;
import '../../shared/models/issues_model.dart';
import '../../shared/utils/static_data.dart';

Future<List<Issue>?> allIssueApiCallService(String authToken) async {
  List<Issue> _allIssueList = [];
  try {
    dev.log("myIssueApiCall called", name: "All Issues API");
    final res = await Dio().get("$host/viewIssue",
        options: Options(headers: {"Authorization": authToken}));
    dev.log(res.statusCode.toString(), name: "All Issues resCode");
    if (res.statusCode != 200) throw Exception("Invalid Status Code");
    if (res.data["success"] != true) throw Exception("Invalid Status Code");
    _allIssueList.clear();
    List myIssuesDataList = res.data["data"];

    for (var element in myIssuesDataList) {
      try {
        _allIssueList.add(Issue.fromJson(element));
      } catch (e) {
        dev.log(e.toString(), name: "All Issues Exception");
      }
    }
  } catch (e) {
    dev.log(e.toString(), name: "All Issues Exception");
    return null;
  }
  return [..._allIssueList];
}
