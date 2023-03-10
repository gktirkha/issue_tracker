import 'dart:developer';

import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:dio/dio.dart';

Future<void> assignIssue(
    {required String issueID,
    required String userID,
    required String authToken}) async {
  try {
    final res = await Dio().post(
      "$host/assignIssue",
      data: {
        "_id": issueID,
        "assignedTo": userID,
      },
      options: Options(
        headers: {
          "Authorization": authToken,
        },
      ),
    );
  } catch (e) {
    log(e.toString(), name: "Assign To Other API");
  }
}
