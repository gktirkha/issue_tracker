import 'dart:developer';

import 'package:brd_issue_tracker/static_data.dart';
import 'package:dio/dio.dart';

Future<void> updateIssueService(
  String title,
  String description,
  String id,
  String priority,
  String? assignToUser,
  String token,
) async {
  try {
    final res = await Dio().patch(
      "$host/api/updateIssue/$id",
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
  } catch (e) {
    log(e.toString(), name: "Update Exception");
  }
}
