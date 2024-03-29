import 'dart:developer';
import 'package:dio/dio.dart';
import '../../shared/models/user_model.dart';
import '../../shared/utils/static_data.dart';

Future<Map<String, List<UserModel>>?> allUsersApi(String token) async {
  Map<String, List<UserModel>> _userMap = {};
  try {
    final res = await Dio().get(
      "$host/viewUser",
      options: Options(headers: {"Authorization": token}),
    );
    if (res.statusCode != 200) {
      throw Exception("Invalid Status Code");
    }
    _userMap.clear();
    List allUser = res.data["data"];
    if (allUser.isEmpty) {
      _userMap.clear();
      return {};
    }
    for (var element in allUser) {
      if (_userMap[element["department"]] == null) {
        _userMap[element["department"]] = [];
      }
      _userMap[element["department"]]!.add(UserModel.formJson(element));
    }

    return {..._userMap};
  } catch (e) {
    log(e.toString(), name: "All User Api Exception");
  }
  return null;
}
