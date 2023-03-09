import 'dart:developer';

import 'package:brd_issue_tracker/static_data.dart';
import 'package:dio/dio.dart';

Future<void> updateUserService({
  required String id,
  required String name,
  required String email,
  required String department,
  required String token,
}) async {
  try {
    await Dio().patch(
      "$host/updateUser/$id",
      data: {
        "name": name,
        "email": email,
        "department": department,
      },
      options: Options(
        headers: {
          "Authorization": token,
        },
      ),
    );
  } catch (e) {
    log(e.toString(), name: "Update User Exception");
  }
}
