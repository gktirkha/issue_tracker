import 'dart:developer';
import 'package:dio/dio.dart';
import '../../shared/utils/static_data.dart';

Future<bool?> deleteUserService(
    {required String id, required String token}) async {
  try {
    final res = await Dio().delete(
      "$host/deleteUser/$id",
      options: Options(
        headers: {"Authorization": token},
      ),
    );
    if (res.data["success"] == false) throw Exception("Delete Failed");
    return true;
  } catch (e) {
    log(e.toString(), name: "Delete Exception");
    return false;
  }
}
