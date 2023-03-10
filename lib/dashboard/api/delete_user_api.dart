import 'dart:developer';

import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:dio/dio.dart';

Future<void> deleteUserService(
    {required String id, required String token}) async {
  try {
    final res = await Dio().delete(
      "$host/deleteUser/$id",
      options: Options(
        headers: {"Authorization": token},
      ),
    );
    if (res.data["success"] == false) throw Exception("Delete Failed");
  } catch (e) {
    log(e.toString(), name: "Delete Exception");
  }
}
