import 'dart:developer';

import 'package:dio/dio.dart';

import '../../shared/utils/static_data.dart';

Future<bool?> deleteIssueService(
    {required String issueId, required String authToken}) async {
  try {
    await Dio().delete(
      "$host/deleteIssue/$issueId",
      data: {"token": authToken},
    );
    return true;
  } catch (e) {
    log(e.toString(), name: "All Issues Exception while delete");
    return false;
  }
}
