import 'dart:developer';
import 'package:dio/dio.dart';
import '../../shared/utils/static_data.dart';

Future<bool?> updateStatusService(
    String id, String status, String token) async {
  try {
    await Dio().patch(
      "$host/updateStatus",
      options: Options(
        headers: {"Authorization": token},
      ),
      data: {
        "_id": id,
        "status": status,
      },
    );
    return true;
  } catch (e) {
    log(e.toString(), name: "Update Exception");
    return false;
  }
}
