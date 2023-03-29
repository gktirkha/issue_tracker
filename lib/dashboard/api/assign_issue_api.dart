import 'dart:developer';
import 'package:dio/dio.dart';
import '../../shared/utils/static_data.dart';

Future<bool?> assignIssue(
    {required String issueID,
    required String userID,
    required String authToken}) async {
  try {
    final res = await Dio().post(
      "$host/assignIssue",
      data: {
        "_id": issueID,
        "assignedTo": userID,
      },
      options: Options(
        headers: {
          "Authorization": authToken,
        },
      ),
    );
    return true;
  } catch (e) {
    log(e.toString(), name: "Assign To Other API");
    return false;
  }
}
