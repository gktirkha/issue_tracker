import 'dart:developer';

import 'package:dio/dio.dart';

import '../../static_data.dart';

Future<void> deleteIssueService(
    {required String issueId, required String authToken}) async {
  try {
    await Dio().delete(
      "$host/deleteIssue/$issueId",
      data: {"token": authToken},
    );
  } catch (e) {
    log(e.toString(), name: "All Issues Exception while delete");
  }
}
