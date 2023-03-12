import 'dart:developer';

import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:dio/dio.dart';

Future<bool?> createUserService({
  required String name,
  required String email,
  required String password,
  required String department,
  required String token,
}) async {
  try {
    await Dio().post("$host/createUser",
        options: Options(
          headers: {"Authorization": token},
        ),
        data: {
          "name": name,
          "email": email,
          "password": password,
          "department": department,
        });
    return true;
  } catch (e) {
    log(e.toString(), name: "Create User Exception");
    return false;
  }
}
