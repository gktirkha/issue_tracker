import 'dart:developer';

import 'package:brd_issue_tracker/static_data.dart';
import 'package:dio/dio.dart';

Future<void> createIssueService({
  required String token,
  required String title,
  required String description,
  required String priority,
  String? assignToId,
}) async {
  try {
    final res = await Dio().post(
      "$host/createIssue",
      data: {
        "title": title,
        "description": description,
        "priority": priority,
        if (assignToId != null) "assignedTo": assignToId,
      },
      options: Options(
        headers: {
          "Authorization": token,
        },
      ),
    );
  } catch (e) {
    log(e.toString(), name: "Create Error");
  }
}
