import 'dart:developer';

import 'package:brd_issue_tracker/static_data.dart';
import 'package:dio/dio.dart';

Future<void> updateStatusService(String id, String status, String token) async {
  try {
    Dio().patch(
      "$host/api/updateStatus",
      options: Options(
        headers: {"Authorization": token},
      ),
      data: {
        "_id": id,
        "status": status,
      },
    );
  } catch (e) {
    log(e.toString(), name: "Update Exception");
  }
}
