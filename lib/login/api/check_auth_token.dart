import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:dio/dio.dart';

Future<bool?> tokenValidationService({required String token}) async {
  try {
    final res = await Dio().get(
      "$host/isTokenValid",
      data: {
        "token": token,
      },
    );
    if (res.statusCode != 200) {
      throw Exception("Invalid Code");
    }
    return res.data["success"];
  } catch (e) {
    return false;
  }
}
