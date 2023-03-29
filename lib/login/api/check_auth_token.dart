import 'package:dio/dio.dart';
import '../../shared/utils/static_data.dart';

Future<bool?> tokenValidationService({required String token}) async {
  try {
    final res = await Dio().get("$host/isTokenValid",
        options: Options(headers: {"Authorization": token}));
    if (res.statusCode != 200) {
      throw Exception("Invalid Code");
    }
    return res.data["success"];
  } catch (e) {
    return false;
  }
}
