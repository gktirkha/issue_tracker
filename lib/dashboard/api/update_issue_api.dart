import 'dart:developer';
import 'package:dio/dio.dart';
import '../../shared/utils/static_data.dart';

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
