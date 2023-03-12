import 'dart:developer';

import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:dio/dio.dart';

Future<bool?> updateIssueService({
  required String title,
  required String description,
  required String id,
  required String priority,
  String? assignToUser,
  required String token,
}) async {
  try {
    final res = await Dio().patch(
      "$host/updateIssue/$id",
      data: {
        "title": title,
        "description": description,
        "priority": priority,
        if (assignToUser != null) "assignedTo": assignToUser
      },
      options: Options(
        headers: {"Authorization": token},
      ),
    );
    return true;
  } catch (e) {
    log(e.toString(), name: "Update Exception");
    return false;
  }
}
