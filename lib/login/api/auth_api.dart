import 'package:dio/dio.dart';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/user_model.dart';
import '../../static_data.dart';

Future<UserModel?> loginService(String email, String password) async {
  UserModel? userModel;
  dev.log("loginServise called", name: "Login Service");
  try {
    final res = await Dio().post(
      "$host/api/Login",
      data: {
        "email": email,
        "password": password,
      },
    );
    if (res.statusCode != 200) throw Exception("Invalid Status Code");
    if (res.data["success"] != true) throw Exception("Invalid Status Code");
    userModel = UserModel.formJson(res.data["data"]);
    await saveUser(userModel);
    dev.log(userModel.token!, name: "Auth Token");
  } catch (e) {
    dev.log(e.toString(), name: "Login Exception");
    return null;
  }
  return userModel;
}

Future<UserModel?> loginCheck() async {
  dev.log("loginCheck called", name: "Login Service");
  final prefs = await SharedPreferences.getInstance();
  final String? id = prefs.getString("id");
  final bool? isAdmin = prefs.getBool("isAdmin");
  final String? token = prefs.getString("token");
  final String? department = prefs.getString("department");
  final String? name = prefs.getString("name");
  if (id != null &&
      isAdmin != null &&
      token != null &&
      department != null &&
      name != null) {
    dev.log(token, name: "Auth Token");
    dev.log(id, name: "Auth id");
    return UserModel(
      id: id,
      isAdmin: isAdmin,
      token: token,
      department: department,
      name: name,
    );
  }
  return null;
}

Future<void> saveUser(UserModel user) async {
  dev.log("saveUser called", name: "Login Service");
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("id", user.id);
  await prefs.setBool("isAdmin", user.isAdmin);
  await prefs.setString("token", user.token!);
  await prefs.setString("department", user.department);
  await prefs.setString("name", user.name);
  dev.log(user.token!, name: "Auth Token");
}

Future<void> logoutService() async {
  dev.log("logout called", name: "Login Service");
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString("token");
  try {
    if (token != null) {
      await Dio().post(
        "$host/api/logout",
        data: {
          "token": token,
        },
      );
    }
  } catch (e) {
    dev.log("Logout Exception", name: "Login Service");
  } finally {
    prefs.remove("id");
    prefs.remove("isAdmin");
    prefs.remove("token");
    prefs.remove("department");
    prefs.remove("name");
  }
}
