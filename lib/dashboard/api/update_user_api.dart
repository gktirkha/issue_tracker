import 'dart:developer';
import 'package:dio/dio.dart';
import '../../shared/utils/static_data.dart';

Future<bool?> updateUserService({
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
    return true;
  } catch (e) {
    log(e.toString(), name: "Update User Exception");
    return false;
  }
}
